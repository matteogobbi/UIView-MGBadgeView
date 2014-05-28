UIView+MGBadgeView
==================

Category which allows to show and customize a badge on every object which inherits from UIView.

<img src="http://i57.tinypic.com/1zbqknl.png" alt="UIView-MGBadgeView Screenshot" width=400px />

## Info

This code must be used under ARC. 
If your code doesn't use ARC you can [mark this source with the compiler flag](http://www.codeography.com/2011/10/10/making-arc-and-non-arc-play-nice.html) `-fobjc-arc` 

## Example Usage

This is an easy example to show and customize the control from code:

``` objective-c
    //Add buttons
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [b1 setBackgroundColor:[UIColor grayColor]];
    [[self view] addSubview:b1];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 50)];
    [b2 setBackgroundColor:[UIColor grayColor]];
    [[self view] addSubview:b2];
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 100, 50)];
    [b3 setBackgroundColor:[UIColor grayColor]];
    [[self view] addSubview:b3];
    
    
    //Customize badges
    [b1.badgeView setBadgeValue:1];
    [b1.badgeView setOutlineWidth:0.0];
    [b1.badgeView setPosition:MGBadgePositionBest];
    [b1.badgeView setBadgeColor:[UIColor blueColor]];
    
    [b2.badgeView setBadgeValue:2];
    [b2.badgeView setOutlineWidth:1.0];
    [b2.badgeView setPosition:MGBadgePositionTopRight];
    [b2.badgeView setOutlineColor:[UIColor blueColor]];
    [b2.badgeView setBadgeColor:[UIColor yellowColor]];
    [b2.badgeView setTextColor:[UIColor blueColor]];
    
    [b3.badgeView setBadgeValue:3];
    [b3.badgeView setPosition:MGBadgePositionTopLeft];
    [b3.badgeView setBadgeColor:[UIColor redColor]];
```

## Contact

Matteo Gobbi

- http://www.matteogobbi.it
- http://github.com/matteogobbi
- http://twitter.com/matteo_gobbi
- https://angel.co/matteo-gobbi
- http://www.linkedin.com/profile/view?id=24211474

## License

MGConferenceDatePicker is available under the MIT license.
