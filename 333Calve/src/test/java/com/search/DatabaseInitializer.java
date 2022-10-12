
package com.search;

import com.google.common.hash.BloomFilter;
import com.google.common.hash.Funnels;
import com.huaban.analysis.jieba.JiebaSegmenter;
import com.huaban.analysis.jieba.SegToken;
import com.search.dao.DataSegmentDao;
import com.search.entity.Data;
import com.search.entity.DataSegment;
import com.search.entity.Segment;
import com.search.service.DataService;
import com.search.service.SegmentService;
import com.search.utils.jieba.keyword.Keyword;
import com.search.utils.jieba.keyword.TFIDFAnalyzer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.*;

// Scan the data table to segment all caption
// one by one and add the segment
@SpringBootTest
public class DatabaseInitializer {

    @Autowired
    private DataService dataService;
    @Autowired
    private SegmentService segmentService;
    @Autowired
    private DataSegmentDao dataSegmentDao;

    TFIDFAnalyzer tfidfAnalyzer=new TFIDFAnalyzer();
    JiebaSegmenter jiebaSegmenter = new JiebaSegmenter();
    static HashSet<String> stopWordsSet = new HashSet<>();

    @Test
    public void InitSegmentTable() {
        List<String> segs = new ArrayList<>();
        // BloomFilter
        BloomFilter<String> bf = BloomFilter.create(Funnels.stringFunnel(Charset.forName("UTF-8")),10000000);

        // loadStopWords
        loadStopWords(stopWordsSet, this.getClass().getResourceAsStream("/jieba/stop_words.txt"));

        {
            // All 30000 data in data are obtained
            List<Data> datas = dataService.getSomeDatas(30000, 0);

            for (int i = 0; i < 3700; i++) {
                // Each piece of data is divided into words
                Data data = datas.get(i % 3700);
                String caption = data.getCaption();

                // Parse the captured caption
                List<SegToken> segTokens = jiebaSegmenter.process(caption, JiebaSegmenter.SegMode.INDEX);
                for (SegToken segToken : segTokens) {
                    String word = segToken.word;
                    if (stopWordsSet.contains(word)) continue; // Determine if it is a stop word
                    // Bloom filter to determine if the word is already included
                    if (!bf.mightContain(word)) {
                        bf.put(word);   // put in Bloom filter
                        segs.add(word); // add in segment table
                    }
                }
            }
        }
        //add all the segments in table
        dataSegmentDao.initSegmentTable(segs);
    }

    @Test
    public void initDataSegRelationTable() {
        // get all segments
        List<Segment> segments = segmentService.getAllSeg();

        // Put the subword into the map as word->id
        Map<String, Integer> wordToId = new HashMap<>(3700);
        for (Segment seg : segments) {
            wordToId.put(seg.getWord(), seg.getId());
        }

        loadStopWords(stopWordsSet, this.getClass().getResourceAsStream("/jieba/stop_words.txt"));

        // a List<DataSegment> represents a DataSegment table
        // dataSegmentListMap represents many DataSegment tables
        Map<Integer, List<DataSegment>> dataSegmentListMap = new HashMap<>(1);
        int cnt = 0;

        {
            List<Data> datas = dataService.getSomeDatas(3700, 0);

            for (int i = 0; i < 3700; i++) {
                // get every data and its caption
//                Data data = datas.get(i % 55040);
                Data data = datas.get(i%3700);
                String caption = data.getCaption();

                // Perform a split
                List<SegToken> segTokens = jiebaSegmenter.process(caption, JiebaSegmenter.SegMode.INDEX);

                // Get the 5 keywords with the highest tfidf value returned
                List<Keyword> keywords = tfidfAnalyzer.analyze(caption,5);
                Map<String, DataSegment> segmentMap = new HashMap<>();

                for (SegToken segToken : segTokens) {
                    String word = segToken.word;

                    // delete stop Words
                    if (stopWordsSet.contains(word)) continue;

                    // remove that are not in the segment table
                    if (!wordToId.containsKey(word)) continue;

                    int segId = wordToId.get(word);
                    int dataId = data.getId();
                    double tf = 0;

                    // If it is one of the 5 keywords with the
                    // highest tfidf value, the tf value is saved
                    for (Keyword v : keywords) {
                        if (v.getName().equals(word)) {
                            tf = v.getTfidfvalue();
                            break;
                        }
                    }

                    if (!segmentMap.containsKey(word)){
                        int count = 1;
                        segmentMap.put(word, new DataSegment(dataId, segId, tf, count));
                    } else {
                        DataSegment dataSegment = segmentMap.get(word);
                        int count = dataSegment.getCount();
                        dataSegment.setCount(++count);
                        segmentMap.put(word, dataSegment);
                    }
                }

                //Place the Segment in the DataSegment table
                // distinguish which DataSegment table to place
                // it in by the Segment's Id, idx being the distinguishing key
                for (DataSegment dataSegment : segmentMap.values()) {
                    int segId = dataSegment.getSegId();
                    int idx = segId % 100;
                    List list = dataSegmentListMap.getOrDefault(idx, new ArrayList<>(370));
                    list.add(dataSegment);
                    dataSegmentListMap.put(idx, list);
                    cnt++;
                }

            }
        }
        
        // Finally create all the DataSegment tables
        // from the dataSegmentList: data_seg_relation
        if (cnt > 0) {
            for (Integer idx : dataSegmentListMap.keySet()) {
                String tableName = "data_seg_relation_" + idx;
                dataSegmentDao.createNewTable(tableName);
                dataSegmentDao.initRelationTable(dataSegmentListMap.get(idx), tableName);
            }
        }
    }
    
    // load stop word
    private void loadStopWords(Set<String> set, InputStream in){
        BufferedReader bufferReader;
        try
        {
            bufferReader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = bufferReader.readLine())!=null) {
                set.add(line.trim());
            }
            bufferReader.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

}
