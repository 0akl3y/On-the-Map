//
//  GenericDataSource.swift
//  On the Map
//
//  Created by Johannes Eichler on 28.04.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit



class GenericDataSource: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    
    var inputData: [AnyObject]
    var cellHandling: (cell: AnyObject) -> AnyObject
    
    //Find out which class the element is
    init(data: [AnyObject], cellHandling: (cell: AnyObject) -> AnyObject){
        
        self.cellHandling = cellHandling
        self.inputData = data
    
    }
    
    
    // MARK: TableView Data Source methods
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return inputData.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!
        let resultingCell = cellHandling(cell: cell) as! UITableViewCell
        
        return resultingCell
        
        
    }
    
    // MARK: CollectionView Data Source methods

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return inputData.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier( "cell", forIndexPath: indexPath) as! UICollectionViewCell
        let resultingCell = cellHandling(cell: cell) as! UICollectionViewCell
        
        return resultingCell
    }

    


}
