package com.search.dao;

import com.search.entity.DataSegment;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DataSegmentDao {
    // for InitlizerTable

    boolean initSegmentTable(@Param("segs")List<String> segs);  // add segment table
    boolean initRelationTable(@Param("relations")List<DataSegment> relations, @Param("tableName")String tableName);  // add relation table
    int createNewTable(@Param("tableName")String tableName); // add table
}
