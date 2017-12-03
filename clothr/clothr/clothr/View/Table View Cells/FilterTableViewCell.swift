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
    
//    var savedImages=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "images") as! Data) as? [Any]
    var brands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
    var pickedBrands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedBrands") as! Data) as? [String]
    var searchBrands=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
    
    var retailers = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
    var pickedRetailers=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedRetailers") as! Data) as? [String]
    var searchRetailers = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
    
    var prices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "price") as! Data) as? [String]
    var pickedPrices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedPrices") as! Data) as? [String]
    var searchPrices = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "price") as! Data) as? [String]
    
    
    var retailerCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailerCheck") as! Data) as? [String: NSInteger]
    var brandCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brandCheck") as! Data) as? [String: NSInteger]
    var priceCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "priceCheck") as! Data) as? [String: NSInteger]
    var colorCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "colorCheck") as! Data) as? [String: NSInteger]
    
    var colors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
    var pickedColors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedColors") as! Data) as? [String]
    var searchColors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
    
    var pickedIndexes=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedIndexes") as! Data) as? [String: NSInteger] //indexes for filter collections
    var pickedRetailerFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedRetailerFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedBrandFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedBrandFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedSizeFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedSizeFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    var pickedColorFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedColorFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    
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
            //set up cell
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
                if indexPath.row==0
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
                if indexPath.row==0
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
//--------------------------------if cell was chosen-------------------------------------//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        addToList.append(objectsArray[indexPath.row])
//        let cell=collectionView.cellForItem(at: indexPath)
        print("touched filter")
        if collectionView==self.savedFilters
        {
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            let text = FilterLabel.text
            if text == "Retailer"
            {
                pickedRetailers?.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                retailerCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
//                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveRetailers()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Brand"
            {
                pickedBrands!.remove(at: indexPath.row)
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath])
                brandCheck![(filterCell.savedFilterLabel.text)!]=0
//                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveBrands()
                saveIndexes()
                filterCollection?.reloadData()
                savedFilters?.reloadData()
            } else if text == "Price Range"
            {
                pickedPrices!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                priceCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
//                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                savePrices()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Color"
            {
                pickedColors!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                colorCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
//                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveColors()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Type of Clothing"
            {
                pickedPrices!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                priceCheck![(filterCell.savedFilterLabel.text)!]=0 //update the filter collection
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                savePrices()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            }
        } else //in filter collection
        {
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
              //if cell was not chosen previously. chosen now
                let text = FilterLabel.text
                if text == "Retailer"
                {
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
                        //                view.sendSubview(toBack: searchCover)
                    } else
//                    print(filterCell.currentFilterLabel.text)
                    if retailerCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedRetailers!.append(filterCell.currentFilterLabel.text!)
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedRetailers!.count-1,section:0) as IndexPath])
                        retailerCheck![filterCell.currentFilterLabel.text!]=1
                        //                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                        let pickedRetailer: PSSRetailer? = (retailers![indexPath.row-1] as! PSSRetailer)
                        let pickedFilter = PSSProductFilter(type: "Retailer", filterID: pickedRetailer?.retailerID)
                        print(pickedRetailer?.retailerID)
                        print(pickedRetailer?.name)
//                         var pickedUserFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedUserFilters") as! Data) as? [Any]
                        pickedRetailerFilters!.append(pickedFilter as Any)
//                        print(pickedUserFilters?.count)
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailerFilters as Any), forKey: "pickedRetailerFilters")
                        saveRetailers()
//                        saveUserFilters()
                        savePickedIndexes()
                        savedFilters?.reloadData()
                         filterCollection?.reloadData()
                    } else
                    {
                        retailerCheck![filterCell.currentFilterLabel.text!]=0
                        pickedRetailers!.remove(at: pickedRetailers!.index(of: filterCell.currentFilterLabel.text!)!)
                        //                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
//                        let pickedRetailer: PSSRetailer? = (retailers![indexPath.row-1] as! PSSRetailer)
//                        let pickedFilter = PSSProductFilter(type: "Retailer", filterID: pickedRetailer?.retailerID)
//                        pickedUserFilters!.append(pickedFilter as Any)
                        let pickedRetailer: PSSRetailer? = (retailers![indexPath.row-1] as! PSSRetailer)
                        if let array = pickedRetailerFilters?.count
                        {
                            for index in 0...array-1
                            {
                                let pickedFilter: PSSProductFilter? = pickedRetailerFilters![index] as? PSSProductFilter
                                if(pickedFilter?.type=="Retailer" && pickedFilter?.filterID==pickedRetailer?.retailerID)
                                {
                                    pickedRetailerFilters?.remove(at: index)
                                }
                            }
                        }
                        saveRetailers()
                        savePickedIndexes()
                        saveUserFilters()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Brand"
                {
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
                        //                view.sendSubview(toBack: searchCover)
                    } else
                    if brandCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedBrands!.append(filterCell.currentFilterLabel.text!)
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedBrands!.count-1,section:0) as IndexPath])
                        brandCheck![filterCell.currentFilterLabel.text!]=1
//                        pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                        let pickedBrand: PSSBrand? = (brands![indexPath.row-1] as! PSSBrand)
//                        print(pickedBrand?.brandID)
//                        print(pickedBrand?.name)
                        let pickedFilter = PSSProductFilter(type: "Brand", filterID: pickedBrand?.brandID)
                        print("filterid: ")
                        print(pickedFilter?.filterID as Any)
//                         var pickedUserFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedUserFilters") as! Data) as? [Any]
                        pickedBrandFilters!.append(pickedFilter as Any)
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrandFilters as Any), forKey: "pickedBrandFilters")
//                        print(pickedBrandFilters?.count)
                        saveUserFilters()
                        saveBrands()
                        savePickedIndexes()
                        savedFilters?.reloadData()
                        filterCollection?.reloadData()
                    } else
                    {
                        brandCheck![filterCell.currentFilterLabel.text!]=0
                        pickedBrands!.remove(at: pickedBrands!.index(of: filterCell.currentFilterLabel.text!)!)
                        //                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                        let pickedBrand: PSSBrand? = (brands![indexPath.row-1] as! PSSBrand)
                        if let array = pickedBrandFilters?.count
                        {
                            for index in 0...array-1
                            {
                                let pickedFilter: PSSProductFilter? = pickedBrandFilters![index] as? PSSProductFilter
                                if(pickedFilter?.type=="Brand" && pickedFilter?.filterID==pickedBrand?.brandID)
                                {
                                    pickedBrandFilters?.remove(at: index)
                                    print("removed")
                                }
                            }
                        }
//                        let pickedFilter = PSSProductFilter(type: "Brand", filterID: pickedBrand?.brandID)
//                        pickedUserFilters.remove
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrandFilters as Any), forKey: "pickedBrandFilters")
                        saveBrands()
                        savePickedIndexes()
//                        saveUserFilters()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Price Range"
                {
                    if priceCheck![filterCell.currentFilterLabel.text!]==0
                    {
                    pickedPrices!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedPrices!.count-1,section:0) as IndexPath])
                    priceCheck![filterCell.currentFilterLabel.text!]=1
//                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                        let pickedFilter = PSSProductFilter(type: "Price", filterID: (7+indexPath.row) as NSNumber)
//                         var pickedUserFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedUserFilters") as! Data) as? [Any]
                        pickedSizeFilters!.append(pickedFilter as Any)
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedSizeFilters as Any), forKey: "pickedSizeFilters")
                        print("filterid: ")
//                        print(pickedUserFilters?.count)
//                        print(pickedFilter?.filterID)
//                    let pickedSize: PSSSize? = (size[indexPath.row] as! PSSSize)
//                    let pickedFilter = PSSProductFilter(type: "Size", filterID: pickedSize?.sizeID)
//                    pickedUserFilters.append(pickedFilter as Any)
//                    let encodedProduct = NSKeyedArchiver.archivedData(withRootObject: pickedUserFilters)
//                    let defaults = UserDefaults.standard
//                    defaults.set(encodedProduct, forKey: "userFilters")
                    savePrices()
                    savePickedIndexes()
                    saveUserFilters()
                    savedFilters?.reloadData()
                    filterCollection?.reloadData()
                    } else
                    {
                        priceCheck![filterCell.currentFilterLabel.text!]=0
                        pickedPrices!.remove(at: pickedPrices!.index(of: filterCell.currentFilterLabel.text!)!)
//                        let pickedBrand: PSSBrand? = (brands![indexPath.row-1] as! PSSBrand)
                        print(pickedSizeFilters?.count)
                        if let array = pickedSizeFilters?.count
                        {
                            for index in 0...array-1
                            {
                                let pickedFilter: PSSProductFilter? = pickedSizeFilters![index] as? PSSProductFilter
                                if(pickedFilter?.type=="Price" && pickedFilter?.filterID==(7+indexPath.row) as NSNumber)
                                {
                                    pickedSizeFilters?.remove(at: index)
                                }
                            }
                        }
//                        print(pickedUserFilters?.count)
                        savePrices()
                        savePickedIndexes()
                        saveUserFilters()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } else if text == "Color"
                {
                    if colorCheck![filterCell.currentFilterLabel.text!]==0
                    {
                        pickedColors!.append(filterCell.currentFilterLabel.text!)
                        savedFilters!.insertItems(at: [NSIndexPath(row: pickedColors!.count-1,section:0) as IndexPath])
                        colorCheck![filterCell.currentFilterLabel.text!]=1
//                        pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                        let pickedColor: PSSColor? = (colors![indexPath.row] as! PSSColor)
                        let pickedFilter = PSSProductFilter(type: "Color", filterID: pickedColor?.colorID)
//                         var pickedUserFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedUserFilters") as! Data) as? [Any]
                        pickedColorFilters!.append(pickedFilter as Any)
                         UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColorFilters as Any), forKey: "pickedColorFilters")
//                        print(pickedUserFilters?.count)
                        saveColors()
//                        saveUserFilters()
                        savePickedIndexes()
                        savedFilters?.reloadData()
                        filterCollection?.reloadData()
                    } else
                    {
                        colorCheck![filterCell.currentFilterLabel.text!]=0
                        pickedColors!.remove(at: pickedColors!.index(of: filterCell.currentFilterLabel.text!)!)
                    //                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                        let pickedColor: PSSColor? = (colors![indexPath.row] as! PSSColor)
                        print(pickedColor?.name)
                        if let array = pickedColorFilters?.count
                        {
                            for index in 0...array-1
                            {
                                let pickedFilter: PSSProductFilter? = pickedColorFilters![index] as? PSSProductFilter
                                if(pickedFilter?.type=="Color" && pickedFilter?.filterID==pickedColor?.colorID)
                                {
                                    pickedColorFilters?.remove(at: index)
                                }
                            }
                        }
                        saveColors()
                        savePickedIndexes()
                        saveUserFilters()
                        filterCollection?.reloadData()
                        savedFilters?.reloadData()
                    }
                } 
        }
    }
    
    func setupDeselectFilter(_ filterCell: FilterCollectionViewCell)
    {
        filterCell.currentFilterBackground.image=UIImage(named: "background")
        filterCell.layer.borderColor=UIColor.black.cgColor
        filterCell.currentFilterLabel.textColor = UIColor.black
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if FilterLabel.text=="Retailer"{
//            print("HIHIHIHIHI")
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
//            print("HERE")
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
    
    
//archiving data
    func saveIndexes()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedIndexes as Any), forKey: "pickedIndexes")
    }
    
    func saveRetailers()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailers as Any), forKey: "pickedRetailers")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: retailerCheck as Any), forKey: "retailerCheck")
    }
    
    func saveBrands()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrands as Any), forKey: "pickedBrands")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: brandCheck as Any), forKey: "brandCheck")
    }
    
    func savePrices()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedPrices as Any), forKey: "pickedPrices")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: priceCheck as Any), forKey: "priceCheck")
    }
    
    func saveColors()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColors as Any), forKey: "pickedColors")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colorCheck as Any), forKey: "colorCheck")
    }
    
    func saveUserFilters()
    {
//        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedUserFilters as Any), forKey: "pickedUserFilters")
//        let pickedRetailerFilters=[Any]()
//        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailerFilters as Any), forKey: "pickedRetailerFilters")
//        let pickedBrandFilters=[Any]()
//        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrandFilters as Any), forKey: "pickedBrandFilters")
//        let pickedSizeFilters=[Any]()
//        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedSizeFilters as Any), forKey: "pickedSizeFilters")
//        let pickedColorFilters=[Any]()
//        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColorFilters as Any), forKey: "pickedColorFilters")
    }
    
    func savePickedIndexes()
    {
         UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedIndexes as Any), forKey: "pickedIndexes")
    }
    
}

