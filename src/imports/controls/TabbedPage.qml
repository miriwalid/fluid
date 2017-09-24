/*
 * This file is part of Fluid.
 *
 * Copyright (C) 2017 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2017 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * $BEGIN_LICENSE:MPL2$
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * $END_LICENSE$
 */

import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Fluid.Core 1.0 as FluidCore
import Fluid.Controls 1.0 as FluidControls

/*!
   \qmltype TabbedPage
   \inqmlmodule Fluid.Controls
   \ingroup fluidcontrols

   \brief Page with tabs.

   \qml
   import QtQuick 2.4
   import Fluid.Controls 1.0 as FluidControls

   FluidControls.ApplicationWindow {
       title: "Application Name"
       width: 1024
       height: 800
       visible: true

       initialPage: FluidControls.TabbedPage {
           FluidControls.Tab {
               title: "Tab 1"

               Label {
                   anchors.centerIn: parent
                   text: "Hello World!"
               }
           }

           FluidControls.Tab {
               title: "Tab 2"

               Label {
                   anchors.centerIn: parent
                   text: "Hello World!"
               }
           }
       }
   }
   \endqml
 */
FluidControls.Page {
    id: page

    /*!
        \internal
     */
    default property alias contents: swipeView.contentChildren

    /*!
        \qmlproperty int count

        Number of tabs.
    */
    property alias count: swipeView.count

    /*!
        \qmlproperty int currentIndex

        Index of the currently selected tab.
    */
    property alias currentIndex: swipeView.currentIndex

    /*!
        \qmlproperty Tab selectedTab

        The currently selected tab.
    */
    readonly property Tab selectedTab: count > 0
                                       ? swipeView.contentChildren[currentIndex] : null

    appBar.elevation: 0

    header: ToolBar {
        visible: tabBar.count > 0

        Material.elevation: 2

        TabBar {
            id: tabBar

            property bool fixed: true
            property bool centered: false

            anchors {
                top: centered ? undefined : parent.top
                left: centered ? undefined : parent.left
                right: centered ? undefined : parent.right
                leftMargin: centered ? 0 : appBar ? appBar.leftKeyline - 12 : 0
                horizontalCenter: centered ? parent.horizontalCenter : undefined
            }

            Material.accent: appBar.Material.foreground
            Material.background: "transparent"

            Repeater {
                model: swipeView.contentChildren
                delegate: TabButton {
                    text: modelData.title
                    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                                         contentItem.implicitWidth +
                                                         (tabIcon.visible ? tabIcon.width : 0) +
                                                         (tabCloseButton.visible ? tabCloseButton.width : 0) +
                                                         leftPadding + rightPadding)
                    width: parent.fixed ? parent.width / parent.count : implicitWidth

                    // Active color
                    Material.accent: appBar.Material.foreground

                    // Unfocused color
                    Material.foreground: FluidCore.Utils.alpha(appBar.Material.foreground, 0.7)

                    FluidControls.Icon {
                        id: tabIcon

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        name: modelData.iconName
                        source: modelData.iconSource
                        visible: status == Image.Ready
                        color: contentItem.color
                    }

                    FluidControls.IconButton {
                        id: tabCloseButton

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: -rightPadding

                        iconName: "navigation/close"
                        iconColor: contentItem.color
                        visible: modelData.canRemove

                        onClicked: swipeView.removeItem(index)
                    }
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
    }

    /*!
        \qmlmethod void TabbedPage::addTab(Tab tab)

        Add a tab programmatically to the page.
     */
    function addTab(tab) {
        swipeView.addItem(tab);
        tabBar.setCurrentIndex(swipeView.count - 1);
    }

    /*!
        \qmlmethod void TabbedPage::removeTab(int index)

        Remove the tab with \a index programmatically.
    */
    function removeTab(index) {
        swipeView.removeItem(index);
        tabBar.decrementCurrentIndex();
    }
}
