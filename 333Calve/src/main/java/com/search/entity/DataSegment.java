package com.search.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
// Raw Java data of a DataSegment table
public class DataSegment {
    Integer dataId;
    Integer segId;
    Double tidif;
    Integer count;

    public DataSegment(int dataId, int segId, double tf, int count) {
        this.dataId=dataId;
        this.segId=segId;
        this.tidif=tf;
        this.count=count;
    }

    public Integer getCount(){
        return count;
    }


    public Integer getSegId(){
        return segId;
    }

    public void setCount(int i){
        count=i;
    }

}
