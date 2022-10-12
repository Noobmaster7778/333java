package com.search.entity;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
// Raw Java data for Segment table
public class Segment {
    private int id;
    private String word;

    //String getWord{return word;}

    public String getWord() {
        return word;
    }

    public Integer getId() {
        return  id;
    }
}

