package com.search.service;

import java.util.ArrayList;
import java.util.Map;


public interface SearchService {

//    Map<String, ArrayList> getDataByKeyword(String keyword, int pageSize, int pageNum);
    Object getDataByKeyword(String keyword, int pageSize, int pageNum);
}