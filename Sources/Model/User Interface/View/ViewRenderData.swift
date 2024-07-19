//
//  ViewRenderData.swift
//  Meta
//
//  Created by david-swift on 13.07.24.
//

/// Information about the widget and wrapper types.
public protocol ViewRenderData {

    /// The type of widget elements (which should be backend-specific).
    associatedtype WidgetType
    /// The wrapper widget.
    associatedtype WrapperType: Wrapper

}
