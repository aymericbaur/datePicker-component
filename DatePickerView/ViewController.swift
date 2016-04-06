//
//  ViewController.swift
//  DatePickerView
//
//  Created by Tip on 02/03/2016.
//  Copyright © 2016 tip. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateViewProtocol {
    @IBOutlet weak var dateFormatControl: UISegmentedControl!
    @IBOutlet weak var regionFormatControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    
    /* Give an index for each Struct (Used for associate dateFormatSegmentedControl selected index to DateFormat value, otherwise you can comment it). */
    private let dateFormatArray: [DateFormat] = [YearMonthDayDateFormat(), YearMonthDateFormat(), YearDateFormat()]
    
    let yAMDatePickerHelper = YAMDatePickerHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give the PickerView its delegate and dataSource:
        datePicker.delegate = yAMDatePickerHelper
        datePicker.dataSource = yAMDatePickerHelper
        yAMDatePickerHelper.updateViewDelegate = self
        
        // Update SegmentedControlRegionFormat number of component and title according to RegionFormat enum:
        regionFormatControl.removeAllSegments()
        for index in 0...RegionFormat.local.rawValue {
            regionFormatControl.insertSegmentWithTitle(RegionFormat(rawValue:index)!.description, atIndex: regionFormatControl.numberOfSegments, animated: false) }
        
        // Select segment:
        regionFormatControl.selectedSegmentIndex = regionFormatControl.numberOfSegments-1
        
        // Set date to current date at start:
        yAMDatePickerHelper.setPickerToDate(datePicker, date: NSDate())
        
        // Update SegmentedControlDateFormat title according to locale format:
        setSegmentedFormatTitle()
    }
    
    //PRAGMA MARK: segmentedControl action
    @IBAction func dateFormatChange(sender: UISegmentedControl) {
        yAMDatePickerHelper.setDateFormat(dateFormatArray[sender.selectedSegmentIndex], inPicker: datePicker)
    }
    
    @IBAction func regionFormatChange(sender: UISegmentedControl) {
        yAMDatePickerHelper.setRegionFormat(RegionFormat(rawValue: sender.selectedSegmentIndex)!, inPicker: datePicker)
        setSegmentedFormatTitle()
    }
    
    // PRAGMA MARK: set date and segmentedTitle
    func setSegmentedFormatTitle() {
        let locale = yAMDatePickerHelper.currentDateFormat.locale
        let LongFormat: String =  NSDateFormatter.dateFormatFromTemplate(dateFormatArray[0].description, options: 0, locale:locale)!
        dateFormatControl.setTitle(LongFormat, forSegmentAtIndex: 0)
        
        let mediumFormat: String =  NSDateFormatter.dateFormatFromTemplate(dateFormatArray[1].description, options: 0, locale:locale)!
        dateFormatControl.setTitle(mediumFormat, forSegmentAtIndex: 1)
        
        let shortFormat: String =  NSDateFormatter.dateFormatFromTemplate(dateFormatArray[2].description, options: 0, locale:locale)!
        dateFormatControl.setTitle(shortFormat, forSegmentAtIndex: 2)
    }
    
    func updateLabel() {
        dateLabel.text = yAMDatePickerHelper.stringRepresentationOfPicker(datePicker)
        
        let datef = NSDateFormatter();
        datef.dateFormat = yAMDatePickerHelper.currentDateFormat.description+"/G";
        print(datef.stringFromDate(yAMDatePickerHelper.dateRepresentationOfPicker(datePicker)))
    }
}