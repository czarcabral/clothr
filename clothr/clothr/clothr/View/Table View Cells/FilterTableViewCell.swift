//
//  FilterTableViewCell.swift
//  clothr
//
//  Created by Andrew Guterres on 11/20/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class FilterTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    //need to: archive picked arrays, figure out sizes if possible, categories?, archive checklists (may want to use dictionary for checklists)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCover: UIView!
    @IBOutlet weak var overallView: UIView!
    @IBOutlet weak var filterCollection: UICollectionView!
    @IBOutlet weak var savedFilters: UICollectionView!
    @IBOutlet weak var filterHeight: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Filter: UIView!
    @IBOutlet weak var FilterLabel: UILabel!
    @IBOutlet weak var FilterView: UIView!
    
//----------------------------------------------unarchiving all filters--------------------------------------------------//
    
    //brand filters from api, saved brands
    var brands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
    var pickedBrands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedBrands") as! Data) as? [String]
    var searchBrands=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
    
    //retailer filters from api, saved retailers
    var retailers = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
    var pickedRetailers=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedRetailers") as! Data) as? [String]
    var searchRetailers = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
    
    //price filters from api, saved prices
    var prices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "price") as! Data) as? [String]
    var pickedPrices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedPrices") as! Data) as? [String]
    var searchPrices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "price") as! Data) as? [String]
    
    //checks to see if a cell is already selected or not (UI)
    var retailerCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailerCheck") as! Data) as? [String: NSInteger]
    var brandCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brandCheck") as! Data) as? [String: NSInteger]
    var priceCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "priceCheck") as! Data) as? [String: NSInteger]
    var colorCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "colorCheck") as! Data) as? [String: NSInteger]
    
    //color filters from api, saved colors
    var colors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
    var pickedColors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedColors") as! Data) as? [String]
    var searchColors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
    
    //chosen filters to be used in the next API query
    var pickedRetailerFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedRetailerFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedBrandFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedBrandFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedPriceFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedPriceFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedColorFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedColorFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    
    //some boolean checks for the search function in the brand/retailer sections
    var brandSearchPressed: NSInteger=0
    var retailerSearchPressed: NSInteger=0
    var searchPressed: NSInteger=0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchBar.delegate=self
        searchBar.returnKeyType = UIReturnKeyType.done
        
//        searchBar.return
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showsDetails = false {
        didSet {
            filterHeight.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(showsDetails ? 250 : 999))
        }
    }
//-----------------------------------------load collection view--------------------------------------------//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(FilterLabel.text)
        if collectionView == self.savedFilters  //if in savedFilters collectionview
        {
            let savedCell=collectionView.dequeueReusableCell(withReuseIdentifier: "savedFilterCell", for: indexPath) as! FilterCollectionViewCell
            //set up cell
            setupChosenCell(savedCell)
            savedCell.savedFilterLabel.textColor=UIColor.white
            let text = FilterLabel.text
            if text == "Retailer"
            {
                savedCell.savedFilterLabel.text = (pickedRetailers?[indexPath.row] )
            } else if text == "Brand"
            {
                savedCell.savedFilterLabel.text=(pickedBrands?[indexPath.row])
            } else if text == "Price Range"
            {
                savedCell.savedFilterLabel.text=(pickedPrices?[indexPath.row])
            } else if text == "Color"
            {
                savedCell.savedFilterLabel.text=(pickedColors?[indexPath.row])
            }
            return savedCell
        } else //if in filterCollection viewController
        {
            let filterCell=collectionView.dequeueReusableCell(withReuseIdentifier: "currentFilterCell", for: indexPath) as! FilterCollectionViewCell
            //set up regular cells that are not chosen yet
            let background = filterCell.currentFilterBackground
            background?.image=UIImage(named:"background")
            background?.layer.cornerRadius=(background?.frame.size.width)!/2
            background?.clipsToBounds=true
            background?.layer.borderWidth=3.0
            background?.layer.borderColor=UIColor.black.cgColor
            filterCell.currentFilterLabel.textColor=UIColor.black
            let text = FilterLabel.text
            if text == "Retailer"
            {
                if indexPath.row==0 //index 0 is saved for the search button
                {
                    let filterCell=collectionView.dequeueReusableCell(withReuseIdentifier: "searchFilterCell", for: indexPath) as! FilterCollectionViewCell
                    setupSearchFilter(filterCell)
                    return filterCell
                }
                let filter: PSSRetailer? = (searchRetailers![indexPath.row-1] as! PSSRetailer)
                if retailerCheck![(filter?.name)!] == 1
                {
                    setupChosenFilter(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                filterCell.currentFilterLabel.text = filter?.name
            } else if text == "Brand"
            {
                if indexPath.row==0 //index 0 is saved for the search button
                {
                    let filterCell=collectionView.dequeueReusableCell(withReuseIdentifier: "searchFilterCell", for: indexPath) as! FilterCollectionViewCell
                    setupSearchFilter(filterCell)
                    return filterCell
                }
                let filter: PSSBrand? = (searchBrands![indexPath.row-1] as! PSSBrand)
                if brandCheck![(filter?.name)!] == 1
                {
                    setupChosenFilter(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                
                filterCell.currentFilterLabel.text=filter?.name
            } else if text == "Price Range"
            {
                if priceCheck![prices![indexPath.row]] == 1
                {
                    setupChosenFilter(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                let filter: String = prices![indexPath.row]
                filterCell.currentFilterLabel.text=filter
            } else if text == "Color"
            {
                let filter: PSSColor? = (colors![indexPath.row] as! PSSColor)
                if colorCheck![(filter?.name)!] == 1
                {
                    setupChosenFilter(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                filterCell.currentFilterLabel.text=filter?.name
            }
            
            return filterCell
        }
        
    }
//----------------------------------------helper functions for setting up collection views--------------------------------//
    func setupSearchFilter(_ filterCell: FilterCollectionViewCell)
    {
        let type = FilterLabel.text
        if type == "Retailer"
        {
            searchPressed=retailerSearchPressed
        } else
        {
            searchPressed=brandSearchPressed
        }
        
        if searchPressed==0
        {
            let background = filterCell.searchBackground
            background?.image=UIImage(named:"background")
            background?.layer.cornerRadius=(background?.frame.size.width)!/2
            background?.clipsToBounds=true
            background?.layer.borderWidth=3.0
            background?.layer.borderColor=UIColor.black.cgColor
            filterCell.searchIcon.image=UIImage(named:"blackSearch")
        } else
        {
            let background = filterCell.searchBackground
            background?.image=UIImage(named:"black")
            background?.layer.cornerRadius=(background?.frame.size.width)!/2
            background?.clipsToBounds=true
            background?.layer.borderWidth=3.0
            background?.layer.borderColor=UIColor.black.cgColor
            filterCell.searchIcon.image=UIImage(named:"whiteSearch")
        }
    }
    
    func setupChosenFilter(_ filterCell: FilterCollectionViewCell)
    {
        let background = filterCell.currentFilterBackground
        background?.image=UIImage(named:"black")
        background?.layer.cornerRadius=(background?.frame.size.width)!/2
        background?.clipsToBounds=true
        background?.layer.borderWidth=3.0
        background?.layer.borderColor=UIColor.black.cgColor
    }
    
    func setupChosenCell(_ filterCell: FilterCollectionViewCell)
    {
        let background = filterCell.savedFilterBackground
        background?.image=UIImage(named:"black")
        background?.layer.cornerRadius=(background?.frame.size.width)!/2
        background?.clipsToBounds=true
        background?.layer.borderWidth=3.0
        background?.layer.borderColor=UIColor.black.cgColor
    }
    
//---------------------------------------returns number of items per collection view---------------------------------------//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.savedFilters
        {
            switch FilterLabel.text
            {
            case "Retailer"?: return pickedRetailers!.count
            case "Brand"?: return pickedBrands!.count
            case "Price Range"?: return pickedPrices!.count
            case "Color"?: return pickedColors!.count
            default:
                return 0
            }
        } else
        {
            switch FilterLabel.text
            {
            case "Retailer"?: return searchRetailers!.count
            case "Brand"?: return searchBrands!.count
            case "Price Range"?: return prices!.count
            case "Color"?: return colors!.count
            default:
                return 0
            }
        }
        
    }
//---------------------------------------------if cell was clicked on------------------------------------------------------//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //------------------------if cell in saved filters collection view is chosen-------------------//
        if collectionView==self.savedFilters
        {
        //the only option a user has when they're here is to remove the filter from their current filters, so only a delete function is necessary
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            let text = FilterLabel.text
            if text == "Retailer"
            {
                pickedRetailers?.remove(at: indexPath.row) //remove filter from saved array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //deletes the cell
                retailerCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
                if let count = retailers?.count //removes the filter from the current filter selection in the API
                {
                    for index in 0...count-1
                    {
                        let filter: PSSRetailer? = retailers![index] as? PSSRetailer
                        if filter?.name==filterCell.savedFilterLabel.text
                        {
                            removeRetailerFilter(filter!)
                            break
                        }
                    }
                }
                saveRetailers()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Brand"
            {
                pickedBrands!.remove(at: indexPath.row) //removes from saved array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //deletes cell
                brandCheck![(filterCell.savedFilterLabel.text)!]=0//update filter collection
                if let count = brands?.count//remove filter from API filters
                {
                    for index in 0...count-1
                    {
                        let filter: PSSBrand? = brands![index] as? PSSBrand
                        if filter?.name==filterCell.savedFilterLabel.text
                        {
                            removeBrandFilter(filter!)
                            break
                        }
                    }
                }
                saveBrands()
                filterCollection?.reloadData()
                savedFilters?.reloadData()
            } else if text == "Price Range"
            {
                pickedPrices!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                priceCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
                if let count = prices?.count
                {
                    for index in 0...count-1
                    {
                        if prices![index]==filterCell.savedFilterLabel.text
                        {
                            removePriceFilter((7+index) as NSNumber)
                            break
                        }
                    }
                }
                savePrices()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Color"
            {
                pickedColors!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                colorCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
                if let count = colors?.count
                {
                    for index in 0...count-1
                    {
                        let filter: PSSColor? = retailers![index] as? PSSColor
                        if filter?.name==filterCell.savedFilterLabel.text
                        {
                            removeColorFilter(filter!)
                            break
                        }
                    }
                }
                saveColors()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            }
        } else
    //------------------------------------if cell in  filters collection view is chosen--------------------------------//
        {
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
              //if cell was not chosen previously. chosen now
                let text = FilterLabel.text
                if text == "Retailer"
                {
                    //if the cell chosen is the search button, allow searching
                    if indexPath.row==0
                    {
                        if filterCell.searchBackground.image==UIImage(named: "background")
                        {
                            self.overallView.sendSubview(toBack: searchCover)
                            retailerSearchPressed=1
                            filterCollection?.reloadData()
                        } else
                        {
                            self.overallView.bringSubview(toFront: searchCover)
                            retailerSearchPressed=0
                            filterCollection?.reloadData()
                        }
                    } else
                    //if the cell chosen has not been selected previously, but is now chosen
                    if retailerCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedRetailers!.append(filterCell.currentFilterLabel.text!)    //add filter to saved filters
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedRetailers!.count-1,section:0) as IndexPath])
                    //set filter boolean to true so the cell's appearance will change
                        retailerCheck![filterCell.currentFilterLabel.text!]=1
                    //add the filter to the api
                        if let count = retailers?.count
                        {
                            for index in 0...count-1
                            {
                                let filter: PSSRetailer? = retailers![index] as? PSSRetailer
                                if filter?.name==filterCell.currentFilterLabel.text
                                {
                                    let pickedRetailer: PSSRetailer? = (retailers![index] as! PSSRetailer)
                                    let pickedFilter = PSSProductFilter(type: "Retailer", filterID: pickedRetailer?.retailerID)
                                    pickedRetailerFilters!.append(pickedFilter as Any)

                                    break
                                }
                            }
                        }
                    //save the filter array
                        saveRetailers()
                    //reload collection views with new cell
                        savedFilters?.reloadData()
                         filterCollection?.reloadData()
                    } else
                    //if the cell has already been chosen, but is now deselected
                    {
                        retailerCheck![filterCell.currentFilterLabel.text!]=0
                        pickedRetailers!.remove(at: pickedRetailers!.index(of: filterCell.currentFilterLabel.text!)!)
                        let pickedRetailer: PSSRetailer? = (retailers![indexPath.row-1] as! PSSRetailer)
                        removeRetailerFilter(pickedRetailer!)
                        saveRetailers()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Brand"
                {
                //if cell is search button
                    if indexPath.row==0
                    {
                        if filterCell.searchBackground.image==UIImage(named: "background")
                        {
                            self.overallView.sendSubview(toBack: searchCover)
                            brandSearchPressed=1
                            filterCollection?.reloadData()
                        } else
                        {
                            self.overallView.bringSubview(toFront: searchCover)
                            brandSearchPressed=0
                            filterCollection?.reloadData()
                        }
                    } else
                //if cell hasn't been previously chosen
                    if brandCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedBrands!.append(filterCell.currentFilterLabel.text!)
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedBrands!.count-1,section:0) as IndexPath])
                        brandCheck![filterCell.currentFilterLabel.text!]=1
                        if let count = brands?.count
                        {
                            for index in 0...count-1
                            {
                                let filter: PSSBrand? = brands![index] as? PSSBrand
                                if filter?.name==filterCell.currentFilterLabel.text
                                {
                                    let pickedBrand: PSSBrand? = (brands![index] as! PSSBrand)
                                    let pickedFilter = PSSProductFilter(type: "Brand", filterID: pickedBrand?.brandID)
                                    print("filterid: ")
                                    print(pickedFilter?.filterID as Any)
                                    pickedBrandFilters!.append(pickedFilter as Any)

                                    break
                                }
                            }
                        }
                        saveBrands()
                        savedFilters?.reloadData()
                        filterCollection?.reloadData()
                    } else
                //if cell has been chosen
                    {
                        brandCheck![filterCell.currentFilterLabel.text!]=0
                        pickedBrands!.remove(at: pickedBrands!.index(of: filterCell.currentFilterLabel.text!)!)
                        let pickedBrand: PSSBrand? = (brands![indexPath.row-1] as! PSSBrand)
                        removeBrandFilter(pickedBrand!)
                        saveBrands()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Price Range"
            //if cell has not been previously chosen
                {
                    if priceCheck![filterCell.currentFilterLabel.text!]==0
                    {
                    pickedPrices!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedPrices!.count-1,section:0) as IndexPath])
                    priceCheck![filterCell.currentFilterLabel.text!]=1
                        if let count = prices?.count
                        {
                            for index in 0...count-1
                            {
                                if prices![index]==filterCell.currentFilterLabel.text
                                {
                                    let pickedFilter = PSSProductFilter(type: "Price", filterID: (7+index) as NSNumber)
                                    pickedPriceFilters!.append(pickedFilter as Any)
                                    print("filterid: ")

                                    break
                                }
                            }
                        }
                    savePrices()
                    savedFilters?.reloadData()
                    filterCollection?.reloadData()
                    } else
                    {
                        priceCheck![filterCell.currentFilterLabel.text!]=0
                        pickedPrices!.remove(at: pickedPrices!.index(of: filterCell.currentFilterLabel.text!)!)
                        removePriceFilter((7+indexPath.row) as NSNumber)
                        savePrices()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Color"
            //if cell has ben chosen
                {
                    if colorCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedColors!.append(filterCell.currentFilterLabel.text!)
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedColors!.count-1,section:0) as IndexPath])
                        colorCheck![filterCell.currentFilterLabel.text!]=1
                        if let count = colors?.count
                        {
                            for index in 0...count-1
                            {
                                let filter: PSSColor? = brands![index] as? PSSColor
                                if filter?.name==filterCell.currentFilterLabel.text
                                {
                                    let pickedColor: PSSColor? = (colors![index] as! PSSColor)
                                    let pickedFilter = PSSProductFilter(type: "Color", filterID: pickedColor?.colorID)
                                    pickedColorFilters!.append(pickedFilter as Any)
                                    break
                                }
                            }
                        }
                        saveColors()
                        savedFilters?.reloadData()
                        filterCollection?.reloadData()
                    } else
                    {
                        colorCheck![filterCell.currentFilterLabel.text!]=0
                        pickedColors!.remove(at: pickedColors!.index(of: filterCell.currentFilterLabel.text!)!)
                        let pickedColor: PSSColor? = (colors![indexPath.row] as! PSSColor)
                        removeColorFilter(pickedColor!)
                        saveColors()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } 
        }
    }
    
//-----------------------------------helper functions for selecting cells in collection views------------------------------//
    func setupDeselectFilter(_ filterCell: FilterCollectionViewCell)
    {
        filterCell.currentFilterBackground.image=UIImage(named: "background")
        filterCell.layer.borderColor=UIColor.black.cgColor
        filterCell.currentFilterLabel.textColor = UIColor.black
    }
    
//------------------------------------setting up search bar for brand and retailers----------------------------------------//
    //*note: we only used a search bar for these two filter because of the large number of filters received from the API
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if FilterLabel.text=="Retailer"{
            if searchText.isEmpty
            {
                searchRetailers = retailers
                self.filterCollection.reloadData()
            } else
            {
                searchRetailers=retailers?.filter({retailer -> Bool in
                    return (retailer as! PSSRetailer).name.lowercased().contains(searchText.lowercased())
                })
            }
        } else
        {
            if searchText.isEmpty
            {
                searchBrands = brands
                self.filterCollection.reloadData()
            } else
            {
                searchBrands=brands?.filter({brand -> Bool in
                    return (brand as! PSSBrand).name.lowercased().contains(searchText.lowercased())
                })
            }
        }
        filterCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
//--------------------------------------functions to remove filters from the API----------------------------------------//
    //functions are called when a cell is deselected. picked filters are the filters to be deleted
    //go through each array, find the chosen filter and check for it's ID. use ID to delete from the concurrent array
    func removeRetailerFilter(_ pickedRetailer: PSSRetailer)
    {
        if let array = pickedRetailerFilters?.count
        {
            for index in 0...array-1
            {
                let pickedFilter: PSSProductFilter? = pickedRetailerFilters![index] as? PSSProductFilter
                if(pickedFilter?.type=="Retailer" && pickedFilter?.filterID==pickedRetailer.retailerID)
                {
                    pickedRetailerFilters?.remove(at: index)
                }
            }
        }
    }
    
    func removeBrandFilter(_ pickedBrand: PSSBrand)
    {
        if let array = pickedBrandFilters?.count
        {
            print(array)
            for index in 0...array-1
            {
                
                let pickedFilter: PSSProductFilter? = pickedBrandFilters![index] as? PSSProductFilter
                if(pickedFilter?.type=="Brand" && pickedFilter?.filterID==pickedBrand.brandID)
                {
                    pickedBrandFilters?.remove(at: index)
                    print("removed")
                }
            }
        }
    }
    
    func removeColorFilter(_ pickedColor: PSSColor)
    {
        if let array = pickedColorFilters?.count
        {
            for index in 0...array-1
            {
                let pickedFilter: PSSProductFilter? = pickedColorFilters![index] as? PSSProductFilter
                if(pickedFilter?.type=="Color" && pickedFilter?.filterID==pickedColor.colorID)
                {
                    pickedColorFilters?.remove(at: index)
                }
            }
        }
    }
    
    func removePriceFilter(_ sizeIndex: NSNumber)
    {
        if let array = pickedPriceFilters?.count
        {
            for index in 0...array-1
            {
                let pickedFilter: PSSProductFilter? = pickedPriceFilters![index] as? PSSProductFilter
                if(pickedFilter?.type=="Price" && pickedFilter?.filterID==sizeIndex)
                {
                    pickedPriceFilters?.remove(at: index)
                }
            }
        }
    }
    
//--------------------------------------------------archiving data------------------------------------------------//
    //these functions save the picked filters for the save collection view, each filter sections selected filters (for UI), and each filter to use in the query for the API
    
    func saveRetailers()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailers as Any), forKey: "pickedRetailers")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: retailerCheck as Any), forKey: "retailerCheck")
         UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailerFilters as Any), forKey: "pickedRetailerFilters")
    }
    
    func saveBrands()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrands as Any), forKey: "pickedBrands")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: brandCheck as Any), forKey: "brandCheck")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrandFilters as Any), forKey: "pickedBrandFilters")
    }
    
    func savePrices()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedPrices as Any), forKey: "pickedPrices")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: priceCheck as Any), forKey: "priceCheck")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedPriceFilters as Any), forKey: "pickedPriceFilters")
    }
    
    func saveColors()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColors as Any), forKey: "pickedColors")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colorCheck as Any), forKey: "colorCheck")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColorFilters as Any), forKey: "pickedColorFilters")
    }
    
}

