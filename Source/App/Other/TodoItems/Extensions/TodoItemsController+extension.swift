//
//  TodoItemsController+extension.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 24/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController {
    public func gestureBeganHandler(_ indexPath: IndexPath?, _ locationInView: CGPoint) {
        if let indexPath = indexPath {
            CellIndexPath.initialIndexPath = indexPath
            let cell = todoListsTable.cellForRow(at: indexPath)
            CellDetail.cellSnapshot  = snapshotFromView(inputView: cell!)
            var center = cell?.center
            CellDetail.cellSnapshot?.center = center!
            CellDetail.cellSnapshot?.alpha = 0.0
            todoListsTable.addSubview(CellDetail.cellSnapshot!)
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center?.y = locationInView.y
                CellDetail.cellIsAnimating = true
                CellDetail.cellSnapshot!.center = center!
                CellDetail.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05,
                                                                       y: 1.05)
                CellDetail.cellSnapshot!.alpha = 0.98
                cell?.alpha = 0.0
            }, completion: { (finished) -> Void in
                if finished {
                    CellDetail.cellIsAnimating = false
                    if CellDetail.cellNeedToShow {
                        CellDetail.cellNeedToShow = false
                        UIView.animate(withDuration: 0.25,
                                       animations: { () -> Void in
                                        cell?.alpha = 1
                        })
                    } else {
                        cell?.isHidden = true
                    }
                }
            })
        }
    }
    
    public func gestureChangedHandler(_ locationInView: CGPoint, _ indexPath: IndexPath?) {
        if CellDetail.cellSnapshot != nil {
            var center = CellDetail.cellSnapshot!.center
            center.y = locationInView.y
            CellDetail.cellSnapshot?.center = center
            if ((indexPath != nil) && (indexPath != CellIndexPath.initialIndexPath)),
                let cellIndexPath = CellIndexPath.initialIndexPath,
                let indexPath = indexPath {
                if cellIndexPath.section != indexPath.section && cellIndexPath.section < indexPath.section {
                    let newSection = indexPath.section + cellIndexPath.section
                    let oldTodo = todos[cellIndexPath.section].value.remove(at: cellIndexPath.row)
                    todos[newSection].value.insert(oldTodo, at: indexPath.row)
                } else if cellIndexPath.section != indexPath.section && cellIndexPath.section > indexPath.section {
                    let oldTodo = todos[cellIndexPath.section].value.remove(at: cellIndexPath.row)
                    todos[indexPath.section].value.insert(oldTodo, at: indexPath.row)
                } else {
                    let oldTodo = todos[indexPath.section].value.remove(at: cellIndexPath.row)
                    todos[indexPath.section].value.insert(oldTodo, at: indexPath.row)
                }
                todoListsTable.moveRow(at: cellIndexPath,
                                       to: indexPath)
                CellIndexPath.initialIndexPath = indexPath
            }
        }
    }
    
    public func handleDefault() {
        if let cellIndexPath = CellIndexPath.initialIndexPath {
            let cell = todoListsTable.cellForRow(at: cellIndexPath)
            if CellDetail.cellIsAnimating {
                CellDetail.cellNeedToShow = true
            } else {
                cell?.isHidden = false
                cell?.alpha = 0.0
            }
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                CellDetail.cellSnapshot?.center = (cell?.center)!
                CellDetail.cellSnapshot?.transform = CGAffineTransform.identity
                CellDetail.cellSnapshot?.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    CellIndexPath.initialIndexPath = nil
                    CellDetail.cellSnapshot?.removeFromSuperview()
                    CellDetail.cellSnapshot = nil
                }
            })
        }
    }
    
    public func snapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
}
