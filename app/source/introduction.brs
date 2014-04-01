' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

function createIntroduction(server as object) as integer
    this = {
        port: createObject("roMessagePort")
        screen: createObject("roListScreen")
        content: introduction_getContentList()
        eventLoop: introduction_eventLoop
    }

    this.screen.setMessagePort(this.port)
    this.screen.setBreadcrumbText("Home", "Introduction")

    this.screen.setContent(this.content)
    this.screen.show()

    this.eventLoop()
end function

function introduction_eventLoop()
    while (true)
        event = wait(0, m.port)
        if type(event) = "roListScreenEvent" then
            if event.isRemoteKeyPressed() then
                if event.getIndex() = 0 then '<BACK>
                    m.screen.close()
                end if
            else if event.isScreenClosed() then
                exit while
            endif
        endif
    end while
end function

function introduction_getContentList() as object
    list = [{
        Title: "Welcome",
        HDBackgroundImageUrl: "pkg:/images/introduction_hd.png",
        SDBackgroundImageUrl: "pkg:/images/introduction_sd.png",
        ShortDescriptionLine1: "Learn about how to use Firefox for Android to send videos to your TV",
    },
    {
        Title: "Prepare your network",
        HDBackgroundImageUrl: "pkg:/images/intro_1.png",
        SDBackgroundImageUrl: "pkg:/images/intro_1.png",
        ShortDescriptionLine1: "Install Firefox and make sure it's on the same network as your Roku",
    },
    {
        Title: "Sending videos",
        HDBackgroundImageUrl: "pkg:/images/intro_2.png",
        SDBackgroundImageUrl: "pkg:/images/intro_2.png",
        ShortDescriptionLine1: "Long tap videos in Firefox to send them to your TV",
    },
    {
        Title: "Control the playback",
        HDBackgroundImageUrl: "pkg:/images/intro_3.png",
        SDBackgroundImageUrl: "pkg:/images/intro_3.png",
        ShortDescriptionLine1: "Use your device to control the video playback on your TV",
    }]
    return list
end function
