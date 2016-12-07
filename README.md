# Liszt-ActionSheet 用法简单.Block回调,扩展性强 
####QQ群:98787555
<img src="https://github.com/LisztGitHub/Liszt-ActionSheet/blob/master/Liszt.gif">
#
####Exmaple
     if(sender.tag-10==0){
        [LisztActionSheet actionSheetTitle:nil cancelButtonTitle:@"取消" otherButtonStrings:@[@"拍照",@"从手机相册选择",@"保存图片"] buttonDidSelectBlock:^(NSInteger index) {
            NSLog(@"index:%li",index);
        }];
    }
    else if(sender.tag-10==1){
        LisztActionSheetButton *button1 = [LisztActionSheetButton configSheetItemTitle:@"删除联系人" titleColor:[UIColor redColor] backgroudColor:[UIColor whiteColor] highlightedColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17.f]];
        
        [LisztActionSheet actionSheetTitle:@"将联系人\"Liszt\"正在删除,同时删除该联系人的所有聊天记录" cancelButtonTitle:@"取消" otherButtonItems:@[button1] buttonDidSelectBlock:^(NSInteger buttonIndex) {
            NSLog(@"index:%li",buttonIndex);
        }];
    }
    else if(sender.tag-10==2){
        LisztActionSheetButton *button1 = [LisztActionSheetButton configSheetItemTitle:@"删除联系人" titleColor:[UIColor cyanColor] backgroudColor:[UIColor whiteColor] highlightedColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17.f]];
        LisztActionSheet *sheet = [LisztActionSheet actionSheetTitle:@"将联系人\"Liszt\"正在删除,同时删除该联系人的所有聊天记录" cancelButtonTitle:@"取消" otherButtonItems:@[button1] buttonDidSelectBlock:^(NSInteger buttonIndex) {
            NSLog(@"index:%li",buttonIndex);
        }];
        sheet.titleBackgroudColor = [UIColor whiteColor];
        sheet.titleColor = [UIColor orangeColor];
        [sheet setCancelTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }

