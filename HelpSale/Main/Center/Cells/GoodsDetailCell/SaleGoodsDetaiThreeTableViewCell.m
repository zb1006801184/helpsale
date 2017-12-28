//
//  SaleGoodsDetaiThreeTableViewCell.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/17.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SaleGoodsDetaiThreeTableViewCell.h"
#import "SalePriceCollectionViewCell.h"
@interface SaleGoodsDetaiThreeTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;


@end

@implementation SaleGoodsDetaiThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configurecell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configurecell {
    UICollectionViewFlowLayout *FL = [[UICollectionViewFlowLayout alloc] init];
    FL.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.mainCollectionView setCollectionViewLayout:FL];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SalePriceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SalePriceCollectionViewCell"];
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
    self.mainCollectionView.alwaysBounceVertical = NO;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(86, 56);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SalePriceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SalePriceCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dataDic = _dataList[indexPath.row];
    cell.nameLabel.text = dataDic[@"user_name"];
    cell.priceLabel.text = dataDic[@"price"];
    return cell;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
                    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}
- (void)setDataList:(NSArray *)dataList {
    if (dataList) {
        _dataList = dataList;
    }
}

@end
