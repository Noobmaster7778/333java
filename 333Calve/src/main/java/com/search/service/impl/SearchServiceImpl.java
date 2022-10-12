package com.search.service.impl;

import com.huaban.analysis.jieba.JiebaSegmenter;
import com.huaban.analysis.jieba.SegToken;
import com.search.dao.DataDao;
import com.search.dao.SegmentDao;
import com.search.entity.Data;
import com.search.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SearchServiceImpl implements SearchService {

    @Autowired
    private DataDao dataDao;

    @Autowired
    private SegmentDao segmentDao;

    @Override
//    public Map<String, Object> getDataByKeyword(String keyword, int pageSize, int pageNum) {

    public Object getDataByKeyword(String keyword, int pageSize, int pageNum) {
            int offset = pageSize * (pageNum - 1);
        StringBuilder sb = new StringBuilder();

        // Perform word segmentation on the input keywords
        JiebaSegmenter segmenter = new JiebaSegmenter();
        List<SegToken> segTokens = segmenter.process(keyword, JiebaSegmenter.SegMode.SEARCH);

        boolean flag = true;
        for (int i = 0; i < segTokens.size(); i++) {
            // get keyword's segment
             if (segmentDao.getOneSeg(segTokens.get(i).word) == null) continue;

            // segment is empty Skip
            if ("".equals(segTokens.get(i).word.trim())) continue;

            // get segId
            int segId = segmentDao.getOneSeg(segTokens.get(i).word).getId();

            // Use segId to find which table to look at (data_segment_relation)
            int idx = segId % 100;

            // Assemble a sql statement to obtain the data_segment for each keyword
            if (flag) {
                sb.append("select * from data_seg_relation_").append(idx).append(" where seg_id = ").append(segId).append('\n');
                flag = false;
            } else {
                sb.append("union").append('\n');
                sb.append("select * from data_seg_relation_").append(idx).append(" where seg_id = ").append(segId).append('\n');
            }

        }
        String sql = sb.toString();

        if ("".equals(sql)) return null;

        // To obtain all Data through sql, see DataMapper.xml for details
        // offset is the first page of the search result
        List<Data> datas = dataDao.getDataBySplit(sql, pageSize, offset);
        Map<String, Object> mp = new HashMap<>();


        mp.put("result", datas);
//        return mp;
        return datas;
    }

}
