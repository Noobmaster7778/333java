package com.search.dao;

import com.search.entity.Data;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DataDao {
    // Get some Data from limit & offset
    List<Data> getSomeDatas(@Param("limit") int limit, @Param("offset") int offset);
    List<Data> getDataBySplit(@Param("sql")String sql, @Param("pageSize")int pageSize, @Param("offset")int offset);
}
