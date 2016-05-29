% basic protocol for crypt analysis

recommended procedure
1 open a image file. choose a ecad file to open.
2 filter stacks. 
    first, use mouse scrool wheel or the left/right arrow on the toolbar to check the quality of stacks.
    then, click the menu 'Setting'->'Stack filter', specify the stack you want to include in later analysis.
3 Z-projection. Click the down-arrow in the toolbar to perform default Z-projection (by coefficient of variation). 
    To change default projection method, click the menu 'Setting'-> 'Default z-projection method'.
    To perform other z-projection method without changing the default setting, click menu 'Projection'.
4 Enhance image. Click the button next to the down-arrow to perform default image enhancement.
    To change default image enhance method, click the menu 'Setting'->'Default image enhancement'.
    To perform other image enhance method without changing the default setting, click menu 'Image'->'Auto-adjust'.
5 Crop crypt. Click the button next to the image enhacne button on toolbar. Use mouse to crop the region you want.
    Double click to stop. The polygon will be automatically closed.
    You can still do image enhancement here.
6 Count dots. Click the button next to the crop button.
    Select the channels you want to count the dots in the popup dialog. Use ctrl to select multiple channels. 
    Wait until a new window popup.
    Check the right panel to see if you are satisfied with the results.
    If satisfied, hit return to start next channel.
    Else click the top left panel to choose another threshold. Refer to the bottom-left panel.
    When all channels are finsihed, a window may popup and let you to decide whether to remove dots present in multiple channels or not.
    To have more control in detecting background dots, click menu item 'Analyze'->'detect background dots'.
7 Segment cells. Click the button next to the crop button.
    Select the dapi image or other image to help segmenting cells.
    A new figure window will popup and show the reference image
    To segment a cell, use mouse to click a polygon around a cell. Double click will close the polygon.
    To delete a cell, right-click inside the cell. On the popup dialog, choose 'delete the cell'
    To stop, right-click, then click stop.

    
    

    
