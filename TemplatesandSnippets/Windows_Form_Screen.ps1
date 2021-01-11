Throw "Make sure the below script is what you want to run.";

Add-Type -Assembly System.Windows.Forms

([System.Windows.Forms.Screen]::AllScreens).Bounds # screen resolution, scaling included
([System.Windows.Forms.Screen]::AllScreens).WorkingArea # screen resolution without taskbar