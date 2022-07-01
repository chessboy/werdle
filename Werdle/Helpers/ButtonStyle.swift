//
//  ButtonStyle.swift
//  Werdle
//
//  Created by Rob Silverman on 6/30/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
	var scale: CGFloat = 1.2
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? scale : 1.0)
	}
}
