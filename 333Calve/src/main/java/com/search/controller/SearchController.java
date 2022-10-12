package com.search.controller;

import com.alibaba.fastjson.JSONObject;
import com.search.service.SearchService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;


@RestController
@ResponseBody
@Slf4j
@RequestMapping("/vue")

public class SearchController {

    // Number of all search results on a page
    private final int resultNumInOnePage = 100;

    @Autowired
    private SearchService searchService;

    @GetMapping("/search")

    public Object searchBySegment(@RequestParam("keywords")String keywords,
                                  @RequestParam("pageNums")Integer pageNums) {

//        System.out.println(keywords+pageNums);
        Object o=searchService.getDataByKeyword(keywords, resultNumInOnePage, pageNums);


        //json object
        JSONObject result = new JSONObject();

        result.put("result",o);

//        System.out.println(o.toString());
//        System.out.println(o instanceof ArrayList);

        System.out.println(result.toJSONString());

//        return result;

        return result.toJSONString();

//        return o;

    }
}
