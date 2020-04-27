//
//  NearbyUserTableCellDelegate.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 18/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import Foundation

protocol NearbyUserTableCellDelegate: class{
    func didUpdateObject(for cell: NearbyUserTableViewCell)
}
