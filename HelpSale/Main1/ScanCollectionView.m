//
//  ScanCollectionView.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanCollectionView.h"
#import "ScanCell.h"

@implementation ScanCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    _index = 0;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    layout.minimumLineSpacing=0;
    
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource=self;
        
        self.delegate=self;
        
        self.pagingEnabled=YES;
        
        [self registerClass:[ScanCell class] forCellWithReuseIdentifier:@"ScanCell"];
        
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    NSLog(@"%lf",contentOffsetX);
    
    self.index = contentOffsetX/(kScreenWidth+40);
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_imageURLArr) {
        
        return _imageURLArr.count;
        
    }else{
    
        return _imageArr.count;

    }
    
    return 0;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ScanCell" forIndexPath:indexPath];
    
    if (_imageURLArr) {
        
        cell.imageURL=_imageURLArr[indexPath.item];

    }else{
        
        cell.image=_imageArr[indexPath.item];

    }
    

    
//    2.把数组传到cell中
    
//    if (_isPhotoSelect) {
//        NSLog(@"%@",_imageURLArr);
//        ZLPhotoAssets *asset = _imageURLArr[indexPath.item];
//        NSLog(@"%@",asset);
//        cell.image = asset.originImage;
//    }else{
//        
//        if (_thumbnailArr) {
//            
//            cell.thumbnailImage = _thumbnailArr[indexPath.item];
//
//        }
//        

//    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.width, self.height);
    
}

//cell已经消失的时候会调用
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanCell *scanCell=(ScanCell*)cell;
    
    //让所有看不到的cell上面的scrollView缩放比例为1
    
}

@end
