# Hardware needs

TO run our own CI and UAT testing we need 2 boxes

TO do UAT we need monitors, keyboard and mouse in a KVM setup.
Options

1. VNC

https://github.com/novnc/noVNC

- Viewer works well for Mobiles also.


2. Logitech hardware / Software
- Logitech Unifying Multi-Connect Utility software
- Logitech Unifying receiver
- Chrome Extension: https://chrome.google.com/webstore/detail/logitech-unifying-for-chr/agpmgihmmmfkbhckmciedmhincdggomo/reviews?hl=en


k375s-multidevice-keyboard



1. Intel nuc running Windows




2. Mac mini

Now Apple are moving all Apple hardware to ARM and so in 2 months everyone will be buying Arm based Laptops and Desktops, and i am designed fro Orgs to be able to run on Laptops

SO now we have 2 Apple Desktop targets to support and Test on.
- I can do UAT testing on my INtel based laptop.
- But we  need a Arm Mac mini so we can UAT test it.

# golang

The Org gateway sever will be running here, and golang compiles to Arm.
But there will be issues with.
- launchd i bet.
- Signing aspects, etc.

We need to test it.

# Flutter

Also our Flutter Desktop will be running there.

SO we must have this hardware to test on BEFORE the users use it.

# Apple links

Developer Transition Kit (DTK)

Flutter are proceeding at a rapid pace to supoort Arm on Desktop.
- Should be not too hard for them as they already compiel to ARM on mobile.
- Expect some Issues with Tooling though.

Announcement from Apple:
https://www.apple.com/newsroom/2020/06/apple-announces-mac-transition-to-apple-silicon/

Application URL:
https://developer.apple.com/programs/universal/
- using ops@gcn.org of course.
- I have mad the application and waiting to hear back.





