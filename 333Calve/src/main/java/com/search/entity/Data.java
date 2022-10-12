package com.search.entity;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@lombok.Data
@AllArgsConstructor
@NoArgsConstructor
// The raw Java object of the Data table
public class Data {
    private Integer id;
    private String url;
    private String caption;



    public String getCaption(){
        return caption;
    }

    public int getId(){
        return id;
    }
}




