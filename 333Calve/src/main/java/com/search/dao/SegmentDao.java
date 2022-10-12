package com.search.dao;

import com.search.entity.Segment;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SegmentDao {

    List<Segment> getAllSeg();

    Segment getOneSeg(String word);
}
