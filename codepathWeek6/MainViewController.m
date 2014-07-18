//
//  MainViewController.m
//  codepathWeek6
//
//  Created by Michael Wang on 7/17/14.
//  Copyright (c) 2014 mkwng. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

- (IBAction)onPress:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *groundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *birdImageView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic,strong) UICollisionBehavior *collision;
@property (nonatomic,strong) UIDynamicItemBehavior *birdBehavior;
@property (nonatomic,strong) UIPushBehavior *push;


@property (nonatomic,strong) UIDynamicItemBehavior *pipeBehavior;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc] init];
    self.collision = [[UICollisionBehavior alloc] init];
    self.birdBehavior = [[UIDynamicItemBehavior alloc] init];
    self.push = [[UIPushBehavior alloc] initWithItems:nil mode:UIPushBehaviorModeInstantaneous];
    self.pipeBehavior = [[UIDynamicItemBehavior alloc] init];
    
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.birdBehavior];
    [self.animator addBehavior:self.push];
    [self.animator addBehavior:self.pipeBehavior];
    
    [self.gravity addItem:self.birdImageView];
    [self.collision addItem:self.birdImageView];
    [self.birdBehavior addItem:self.birdImageView];
    [self.push addItem:self.birdImageView];
    
    self.birdBehavior.elasticity = .5;
    self.birdBehavior.density = 100;
    self.push.pushDirection = CGVectorMake(0, -80);
    self.pipeBehavior.resistance = 0;
    self.pipeBehavior.density = .1;
    self.gravity.magnitude = 1.8;
    self.collision.collisionDelegate = self;
    
    
//    [self.collision addBoundaryWithIdentifier:@"shelf" fromPoint:CGPointMake(0,512) toPoint:CGPointMake(320, 512)];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(addPipes) userInfo:nil repeats:YES];
//    [timer fire];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p
{
    
//    UIView *view = (UIView *)item;
//    if (identifier==nil) {
        NSLog(@"test");
    
//    }
    
}


- (IBAction)onPress:(UIGestureRecognizer *)longPressGestureRecognizer
{
    if(longPressGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        float velocity = [self.birdBehavior linearVelocityForItem:self.birdImageView].y;
        
        [self.birdBehavior addLinearVelocity:CGPointMake(0,-velocity) forItem:self.birdImageView];
        self.push.active = YES;
        
    }
    

}


- (void)addPipes
{
    UIImage *pipednImage = [UIImage imageNamed:@"pipedn.png"];
    UIImage *pipeupImage = [UIImage imageNamed:@"pipeup.png"];

    UIImageView *pipeTop = [[UIImageView alloc] initWithImage:pipeupImage];
    pipeTop.frame = CGRectMake(320,-80.0 * arc4random_uniform(3),pipeupImage.size.width,pipeupImage.size.height);
    
    
    UIImageView *pipeBot = [[UIImageView alloc] initWithImage:pipednImage];
    pipeBot.frame = CGRectMake(320,pipeTop.frame.origin.y + pipednImage.size.height + 100,pipednImage.size.width,pipednImage.size.height);
    
    
    [self.view addSubview:pipeTop];
    [self.view addSubview:pipeBot];
    
    [self.collision addItem:pipeTop];
    [self.collision addItem:pipeBot];
    
    [self.pipeBehavior addItem:pipeTop];
    [self.pipeBehavior addItem:pipeBot];
    
    [self.pipeBehavior addLinearVelocity:CGPointMake(-200, 0) forItem:pipeTop];
    [self.pipeBehavior addLinearVelocity:CGPointMake(-200, 0) forItem:pipeBot];
}

@end
