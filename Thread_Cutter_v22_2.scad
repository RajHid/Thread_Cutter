// * Discription what the *.scad is about ect.

// ==================================
// = Used Libraries =
// ==================================

// Änderung
// Eine Zweite Änderung

// ==================================
// = Variables =
// ==================================

// sizing or printing or print a small part to test the object.
DesignStatus="Tread_Dimension_CUT_Test";//["sizing","Thread_Object_Innward","sizing_Inn_Cut","Thread_Object_Outward","sizing_Out_Cut","fitting","Tread_Dimension_CUT_Test","printing","printing_2","coloring"]
//      "sizing": 
//      "Thread_Object_Innward":
//      "sizing_Inn_Cut":
//----------------------------------
//  "Thread_Object_Outward": (ridge faching outward)
////    On the lid:
////    -   cut full trough open end
////    -   cut of Spiral at the top of the lid, aka roof of the lid
////    on the can:
////    - apply Higbee at both ends
// "sizing_Out_Cut":
// "fitting":
// "Tread_Dimension_CUT_Test":
// "printing":                  Printable Assembly part_1, part_2, ...


// ==== Can ====
Durchmesser_Flasche=25.0;
HoeheFlasche=10.0;
Wandstaerke_Flasche=1.50;
BottomThickness=1.00;
// ==== Lid ====
WandstaerkeDeckel=1.50;
HoeheDeckel=7.0;
TopThickness=0.70;

// ==== Fitting helpers ====
Spacing_Lid_Can_Cylinder=0.10;
Spacing_Lid_Can_Top=0.10;
rotation_Diff_Lid_Can=0.0;

// ==== Tread ====
//Choosing a Profile for the trad
TOOTH_PROFILE="Trapezoid"; //["Trapezoid","SQUARE","TREAD_TOOTH","TOOTH-ON-TOOTH"]
// Choosing wich direction the tread is faching
Treaddirection="Outward"; //["Outward","Innward","Tread_on_Tread"]

//Strings="foo"; // [foo, bar, baz]

D1_CYLINDER=Durchmesser_Flasche;
H1_CYLINDER=HoeheDeckel-TopThickness;

echo("D1_CYLINDER",D1_CYLINDER);
echo("H1_CYLINDER",H1_CYLINDER);

// === Helix Parameters ===

// Degrees the helix ascends
ASCENT_Deg=12.0;
// Number of Threads
THREAD_COUNT=5;
// Degrees the helixsegments the helix is made of take in each step. aka 1° will get you 360 segments the helix is made of.
ARC_STEP_INCREMENT_DEGREES=360/76;// Size of one subobject aka the Arc lenght of the Extrusion of the Treadprofile, the wohle Thtread gets assembled by putting them together step by step

// Length of the Higgbee Cut is determined by x times Arc ARC_STEP_INCREMENT_DEGREES (aka 6° if 1°)
HigbeeIncrementrs=6;
HiggBee=ARC_STEP_INCREMENT_DEGREES*HigbeeIncrementrs;

// The Screw head diameter
ScrewMount_D=15;
// The Height of the Screw head
Screw_Head_H=2.5;

module __Customizer_Limit__ () {}  // bevfore these the variables are usable in the cutomizer
shown_by_customizer = false;

// === Facettes Numbers ===

FN_HexNut=6;
FN_Performance=36;
FN_FooBaa=12;
// Divisebile by 4 to align Cylinders whithout small intersections
FN_Rough=12;
FN_MediumRough=16;
FN_Medium=36;
FN_Fine=72;
FN_ExtraFine=144;

RENDERMODUS=32;
FN_RENDERMODUS=RENDERMODUS;

// provides a $fn-Value for all cylinders that fits that of the helix, to avoid smal artifacts that would cause problems becaus of not closed surface or intersections whititself 
FN_FACETETTES_NUMBER=360/ARC_STEP_INCREMENT_DEGREES;

function FN_Facettes(x) = 1;

// Heght of the used Profile of the Thread
// needed for corection and ajustments on MAX_DEGREE
Tooth_Profile_Height=4.25;
// Aditional parameter to modify the length of MAX_DEGREE so the thread will cut throug the objekt compleatly at the Ends
// Problem is that the thread is based on a middle line and the height/MAX_DEGREE is calculatet on that parameter. The Tooth Profile is perpendicular to that.
// So the ends of the instance of the cutting Thread will bee a little bit to Short.
// The faulty result would be a to narrow cut to fit the Thread
MAX_DEGREE_END=round(360*(Tooth_Profile_Height/((D1_CYLINDER*PI)*tan(ASCENT_Deg))));
echo("MAX_DEGREE_END",MAX_DEGREE_END);
// Parameter that provides the correct amount of degrees the Helix Rotates to met the Height of a bottle cap, aka the helix fits in the height of the bottle cap

MAX_DEGREE=round(360*(H1_CYLINDER/((D1_CYLINDER*PI)*tan(ASCENT_Deg)))); // --> Gets used in iterator now due to need of parametering the Start and end of the Spiral, Spiral needs to be longer to cut fully trough
echo("MAX_DEGREE",MAX_DEGREE);

// Cutter or Actual Tread ("Cut" slith vs "ADD" tooth)
ThreadDeterminator="CUT"; //  [CUT:Cutting, ADD:Adding]
// Determines the direction the Thread will have, or tooth on tooth 
Direction="INN"; // [INN:Innward, OUT:Outward, TOTH:Tooth on Tooth]
// Delta of the Shape, cut is bigger than tooth, for Whitworth or trapezoidal thread... tooth has to fit in the cut
ThreadSpaceing=0.125;
// Cuts a Space between the Lid and the Bottle
CylinderSpacingCut=0.15;
// determines the Radius of a Cylinder that will cut from the lid AND/OR the Cylinder of the bottle, aka the Bottle has D=80mm the Lid has a inner diameter of 80mm. CylinderSpacingCut = 3mm, with CylinderSpacingCutBaseCenter = 2mm and Outward, there will 1mm be cut of the Bottle 2mm from the inner cylinder of the Lid so that it will be bigger
CylinderSpacingCutBaseCenter=0.15;        

// Vector that containes All Values of the Thread
// HelixParameterVECTOR=[ThreadDeterminator,Direction,ThreadSpaceing,HiggBeeEndtreatment];
//
// HelixParameterVECTOR_2=[    Direction,              // Direction of the Thread, The Cuts can be in the Can or in the Lid.
//                            ThreadDeterminator,     // Decides between a Cut and a Add,
//                            ThreadSpaceing,         // A parameter for the Cutting Operation to get a sligtly bigger Cut so that the pices will fit to each other
//                            A,                      // Determines if the ThreadSpacing is applied to make the Cut slightly bigger Just a multiplication by 1 or 0
//                            HiggBeeEndtreatment     // Number from 0 to 3 decides were a HiggBee Cut is Applied
//                        
// ];

// Amount the Helix Rises on each segment.
ASCENT_STEP=(tan(ASCENT_Deg)*D1_CYLINDER*PI/360);
echo(ASCENT_STEP,"ASCENT_STEP");

//// sizing printing or print a small part to test the object.
//DesignStatus="sizing"; // ["sizing","fitting","printing"]
//// Variables seen by customizer
//
//TestSlab_X=50;
//TestSlab_Y=100;
//TestSlab_Z=30;
//
//TestCylinder_H=35;
//TestCylinder_D1=25;
//TestCylinder_D2=45;
//
//TestSphere_D=42;
//
//module __Customizer_Limit__ () {}  // before these, the variables are usable in the cutomizer
//shown_by_customizer = false;
//
//Invisible=42;
//TestslabTransl_X=25;
//TestslabRotate_X=30;

// ==================================
// = Tuning Variables =
// ==================================
// Variables for finetuning (The Slegehammer if something has to be made fit)

// ==================================
// = Customizer Section =
// ==================================

/* Spicker ... ;-P
// ==== Can ====        (CANHEIGHT=45,CANDIAMETER=45,CANWALLTHICKNESS=5,CANBOTTOMTHICKNESS=2)
HoeheFlasche=10;
Durchmesser_Flasche=25;
Wandstaerke_Flasche=1.5;
BottomThickness=1;
// ==== Lid ====        (LIDHEIGHT=25,CANDIAMETER=45,LIDWALLTHICKNESS=5,LIDTOPTHICKNESS=2,Spacing_Lid_Can_Cylinder=0.5)
HoeheDeckel=7;
WandstaerkeDeckel=1.5;
TopThickness=0.7;
*/
if (DesignStatus=="printing"){
    // the parts gets sprayed out to print them
    // heigh resolution
    difference(){
        Main_Assembly(  36,
                        76,
                        "false",        // showing ("false") or cutting the tread
                        "false"){
        //difference(){
            //union(){
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness]){
                    Lid(    HoeheDeckel,//                                                                          Child [0]
                            Durchmesser_Flasche,
                            WandstaerkeDeckel,
                            TopThickness,
                            Spacing_Lid_Can_Cylinder           );
                }
                Can(    HoeheFlasche,//                                                                         Child [1]
                        Durchmesser_Flasche,
                        Wandstaerke_Flasche,
                        BottomThickness                    );
                Helixiterator( 0,//                                                                             Child [2]
                                0,
                                HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                                ["ADD",
                                "INN",
                                ThreadSpaceing,
                                1,
                                6*5]       
                                                            );
                Helixiterator( 0,//                                                                             Child [3]
                                0,
                                HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                                ["CUT",
                                "INN",
                                ThreadSpaceing,
                                1,
                                6*5]       
                                                            );
                Top_Spaching_Difference_Cut(            HoeheFlasche,
                                                        Durchmesser_Flasche,
                                                        Spacing_Lid_Can_Top,
                                                        Spacing_Lid_Can_Cylinder,
                                                        36,76); //                                              Child [4]
                #Can_to_Lid_Spaching_Difference_Cut(     HoeheFlasche,      //                                  Child [5]
                                                        Durchmesser_Flasche,     // CANDIAMETER
                                                        Wandstaerke_Flasche,      // CANWALLTHICKNESS
                                                        Spacing_Lid_Can_Cylinder,   // SPACING_LID_CAN_CYLINDER
                                                        H1_CYLINDER,    // heigt of the Helix!
                                                        36,76); // $fn Resolution See vs final Render
        //        Treadmaker(    THREADDIRECTION="INN",
        //                        DETERMINATOR="ADD",
        //                        X=0,
        //                        Y=0,
        //                        Z=HoeheFlasche-HoeheDeckel+TopThickness,
        //                        HiggBeeEndtreatment=0,
        //                        HIGG_BEE=0            );
            //}
        }
        translate([15,15,0]){
            //cube([30,30,150],center=true);
        }
    }    
}
if (DesignStatus=="printing_2"){
    // the parts gets sprayed out to print them
    // heigh resolution
    difference(){
        Main_Assembly_2(  36,
                        76,
                        false,        // showing ("false") or cutting the tread
                        false){
        //difference(){
            //union(){
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness]){
                    Lid(    HoeheDeckel,//                                                                          Child [0]
                            Durchmesser_Flasche,
                            WandstaerkeDeckel,
                            TopThickness,
                            Spacing_Lid_Can_Cylinder           );
                }
                Can(    HoeheFlasche,//                                                                         Child [1]
                        Durchmesser_Flasche,
                        Wandstaerke_Flasche,
                        BottomThickness                    );
                Helixiterator( 0,//                                                                             Child [2]
                                0,
                                HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                                ["ADD",
                                "INN",
                                ThreadSpaceing,
                                1,
                                6*5]       
                                                            );
                Helixiterator( 0,//                                                                             Child [3]
                                0,
                                HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                                ["CUT",
                                "INN",
                                ThreadSpaceing,
                                1,
                                6*5]       
                                                            );
                Top_Spaching_Difference_Cut(            HoeheFlasche,
                                                        Durchmesser_Flasche,
                                                        Spacing_Lid_Can_Top,
                                                        Spacing_Lid_Can_Cylinder,
                                                        36,76); //                                          Child [4]
                Can_to_Lid_Spaching_Difference_Cut(     HoeheFlasche,      //                                   Child [5]
                                                        Durchmesser_Flasche,     // CANDIAMETER
                                                        Wandstaerke_Flasche,      // CANWALLTHICKNESS
                                                        Spacing_Lid_Can_Cylinder,   // SPACING_LID_CAN_CYLINDER
                                                        H1_CYLINDER,    // heigt of the Helix!
                                                        36,76); // $fn Resolution See vs final Render
        //        Treadmaker(    THREADDIRECTION="INN",
        //                        DETERMINATOR="ADD",
        //                        X=0,
        //                        Y=0,
        //                        Z=HoeheFlasche-HoeheDeckel+TopThickness,
        //                        HiggBeeEndtreatment=0,
        //                        HIGG_BEE=0            );
            //}
        }
        translate([15,15,0]){
            cube([30,30,150],center=true);
        }
    }    
}
if(DesignStatus=="fitting"){
    intersection(){
        translate([0,0,1]){
            cube([1000,1000,1],center=true);
        }
        Main_Assembly(16,76,"false"){
        }
    }
}
if (DesignStatus=="sizing"){
    Main_Assembly(16,76,"true"){
        Lid();
        Can();
        sphere(r=12);
        cube(22,center=true);
        }
}
if (DesignStatus=="coloring"){
    Deutsches_Welle_Polen(36,76,100){
        translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness]){        
        Helixiterator(  0,//                                                                             Child [2]
                        0,
                        HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                        ["ADD",
                        "INN",
                        ThreadSpaceing,
                        1,
                        6*5]            );
        }
    }
}

if (DesignStatus=="Thread_Object_Innward"){
    Deutsches_Welle_Polen(36,76,100){
        translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness]){        
        Helixiterator(  0,//                                                                             Child [2]
                        0,
                        HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                        ["ADD",
                        "INN",
                        ThreadSpaceing,
                        1,
                        6*5]            );
        }
    }
}
if (DesignStatus=="Thread_Object_Outward"){
    Deutsches_Welle_Polen(36,76,100){
        translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness]){        
        Helixiterator(  0,//                                                                             Child [2]
                        0,
                        HoeheFlasche-HoeheDeckel+TopThickness+BottomThickness,
                        ["ADD",
                        "OUT",
                        ThreadSpaceing,
                        0,
                        6*5]            );
        }
    }
}
// ==================================
// = MAINASSEMBLY =
// ==================================
// LOW_RESOLUTION: low reaulution value to speed up preview
// HIGH_RESOLUTION: high resolution value for rendering the .stl
// CUT_MODULES_RENDERED: decides if the cuttingmodules get renderred to see them. use cuttingmodules twice one time within the final part to cut and one time to just schow it.
// CUTTING_IS_SET: true or false to decide if the cutings to show a cross section gets applied
// Main_Assembly(12,76,true);
module Main_Assembly(LOW_RESOLUTION=12,HIGH_RESOLUTION=36,CUT_MODULES_RENDERED,CUTTING_IS_SET){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
// === makes ist bunt
    Deutsches_Welle_Polen(16,76,255/1){
//    see_me_in_colourful(CUTTING_IS_SET){
        translate([0,0,0]){
            difference(){
                children(1);
                union(){
                    //children(0);
                    //TEST_OBJECT();
                    children(3);
//                    translate([25,40,15]){                    
//                        scale([0.4,0.4,0.4]){        
//                            //TEST_CUTCUBE();
//                        }
//                    }
                }
            }
        }
    }
    Deutsches_Welle_Polen(16,76,255/2){
        difference(){
            children(0);
            union(){
                children(4);
                //children(5); 
            }
            union(){
                children(5);
            }
        }
        difference(){
            children(2);
            //  Upper Cut of Thread helix
            translate([0,0,HoeheFlasche+Spacing_Lid_Can_Top]){
                cylinder(h=H1_CYLINDER,d=60);
            }
            //  Lower Cut of Thread helix
            translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top-H1_CYLINDER]){ 
                cylinder(h=H1_CYLINDER,d=60);
            }
        }
    }
    Deutsches_Welle_Polen(16,76,255/3){
        if(CUT_MODULES_RENDERED=="true"){
            translate([0,0,0]){
                children(2); 
                }
            translate([0,0,0]){
                children(4);
            }
            translate([0,0,0]){
                children(5);
            }
        }
        else{
                echo("CUT_MODULES_RENDERED= ",CUT_MODULES_RENDERED);
            }
        translate([0,0,0]){
        }
        union(){
            
        }
        translate([ 0,0,50]){
            difference(){
                //children(2);
                //children(3);
            }
        }
    }
}
//!render(convexity=1){
//    difference(){
//        cube(50);
//        sphere(50);
//    }
//}
module Main_Assembly_2(LOW_RESOLUTION=12,HIGH_RESOLUTION=36,CUT_MODULES_RENDERED,CUTTING_IS_SET){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
// === makes it bunt
    Collor_it_Ruffly(1/255*160,1/255*176,1/255*200,CUTTING_IS_SET){
    //    see_me_in_colourful(CUTTING_IS_SET){
        translate([0,0,0]){
            difference(){
                render(convexity=10){children(1);}
                union(){
                    //children(0);
                    //TEST_OBJECT();
                    Collor_it_Ruffly(1/255*60,1/255*76,1/255*20,CUTTING_IS_SET){
                        render(convexity=10){children(3);}
                    }
    //                    translate([25,40,15]){                    
    //                        scale([0.4,0.4,0.4]){        
    //                            //TEST_CUTCUBE();
    //                        }
    //                    }
                }
            }
        }
    }
    Collor_it_Ruffly(1/255*160,1/255*176,1/255*100,CUTTING_IS_SET){
        difference(){
            render(convexity=10){children(0);}
            union(){
                render(convexity=10){children(4);}
                //children(5); 
            }
            union(){
                render(convexity=10){children(5);}
            }
        }
        difference(){
            render(convexity=10){children(2);}
            //  Upper Cut of Thread helix
            translate([0,0,HoeheFlasche+Spacing_Lid_Can_Top]){
                render(convexity=10){cylinder(h=H1_CYLINDER,d=60);}
            }
            //  Lower Cut of Thread helix
            translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top-H1_CYLINDER]){ 
                render(convexity=10){cylinder(h=H1_CYLINDER,d=60);}
            }
        }
    }
    Collor_it_Ruffly(1/255*60,1/255*176,1/255*100,CUTTING_IS_SET){
        if(CUT_MODULES_RENDERED==true){
            translate([0,0,0]){
                render(convexity=10){children(2);} 
                }
            translate([0,0,0]){
                children(4);
            }
            translate([0,0,0]){
                render(convexity=10){children(5);}
            }
        }
        else{
                echo("CUT_MODULES_RENDERED= ",CUT_MODULES_RENDERED);
            }
        translate([0,0,0]){
        }
        union(){
            
        }
        translate([ 0,0,50]){
            difference(){
                //children(2);
                //children(3);
            }
        }
    }
}
// ===============================================================================
// =----- Module to help coloring different modules to make it easier 
// ===============================================================================
module see_me_in_colourful(CUTTING_IS_SET="false"){ // iterates the given modules and colors them automaticly by setting values using trigonometric funktions
    translate([0,0,0]){
        for(i=[0:1:$children-1]){
            a=255;
            b=50;       // cuts away the dark colors to prevent bad visual contrast to backgound
            k_farbabstand=((a-b)/$children);
            Farbe=((k_farbabstand*i)/255);
            SINUS_Foo=0.5+(sin(((360/(a-b))*k_farbabstand)*(i+1)))/2;
            COSIN_Foo=0.5+(cos(((360/(a-b))*k_farbabstand)*(i+1)))/2;
            color(c = [ SINUS_Foo,
                        1-(SINUS_Foo/2+COSIN_Foo/2),
                        COSIN_Foo],
                        alpha = 0.5){
//                if (i>=6){
//                    render(convexity=4){children(i);}
//                    }
                difference(){
                    render(convexity=10){children(i);} //renders the modules, effect is that inner caveties become visible
                    children(i);
                    translate([70/2,0,0]){
                        //cube([80,90,150],center=true);
                    }
// Creates a Cutting to see a Sidesection cut of the objects
                    color(c = [ SINUS_Foo,
                                1-(SINUS_Foo/2+COSIN_Foo/2),
                                COSIN_Foo],
                                alpha = 0.0)                    {
                        if(CUTTING_IS_SET=="true"){
                            translate([15,15,0]){
                                cube([30,30,150],center=true);
                            }
                            translate([0,0,10]){
                                //TILT_CUT(ASCENT_Deg,0,40,30);
                            }
                            translate([-50,-50,0]){
                                //cube([100,50,200],center=false);
                            }
                        }
                        else{echo("Crosscutting=",CUTTING_IS_SET);}
                    }
                }
            }
        }
    }
}
module Deutsches_Welle_Polen(LOW_RESOLUTION=36,HIGH_RESOLUTION=76,COLORSTART){ // In Farbe und Bunt
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
// cutting Modules
//
    for(i=[0:1:$children-1]){    
        a=255;
        b=50;       // cuts away the dark colors to prevent bad visual contrast to backgound
        k_farbabstand=((a-b)/$children)+COLORSTART; // $children provides the index of the used child, Each child gets a equidistat color to each other
        //Farbe=((k_farbabstand*i)/255);
        SINUS_Foo=0.5+(sin(((360/(a-b))*k_farbabstand)*(i+1)))/2;
        COSIN_Foo=0.5+(cos(((360/(a-b))*k_farbabstand)*(i+1)))/2;
        color(c = [ SINUS_Foo,
                    1-(SINUS_Foo/2+COSIN_Foo/2),
                    COSIN_Foo],
                    alpha = 0.5){
            render(convexity=10){children(i);} //renders the modules, effect is that inner caveties become visible
            //children(i);
        }
    }
}
module Collor_it_Ruffly(RED=124,GRN=124,BLU=124,CUT_It=false){
    difference(){
        color(c=[   RED,
                    GRN,
                    BLU  ], alpha=0.5 ){
            render(convexity=10){children();}
        }
        if (CUT_It==true){
            cube([50,50,50]);
            echo("Sectional modell",CUT_It);
        }
        else{
            echo("Sectional modell",CUT_It);
        }
    }
}
//TILT_CUT(TILT_ANGLE=10,ROT_ANGLE_ALIGN=0,HEIGHT=50,DIAMETER=35);
module TILT_CUT(TILT_ANGLE=80,ROT_ANGLE_ALIGN=-90,HEIGHT=50,DIAMETER=35){
    rotate([TILT_ANGLE,0,ROT_ANGLE_ALIGN]){
        cylinder(h=HEIGHT,d=DIAMETER);
    
    }
}
// ===============================================================================
// =--------------------------------- Enviroment Modules ------------------------=
// ===============================================================================
// Modules that resembles the Enviroment aka the helmet where to atach a camera mount or the Object the Tread gets applied to

//Lid();
module Lid(LIDHEIGHT=25,CANDIAMETER=45,LIDWALLTHICKNESS=5,LIDTOPTHICKNESS=2,Spacing_Lid_Can_Cylinder=0.5){
    translate([0,0,0]){
        difference(){
            cylinder(h=LIDHEIGHT,d=CANDIAMETER+2*LIDWALLTHICKNESS);
            translate([0,0,-LIDTOPTHICKNESS]){
                cylinder(h=LIDHEIGHT,d=CANDIAMETER); 
            }
        }
    }
}
//Can();
module Can(CANHEIGHT=45,CANDIAMETER=45,CANWALLTHICKNESS=5,CANBOTTOMTHICKNESS=2,){
    difference(){
        cylinder(h=CANHEIGHT,d=CANDIAMETER);
        translate([0,0,CANBOTTOMTHICKNESS]){
            cylinder(h=CANHEIGHT,d=CANDIAMETER-2*CANWALLTHICKNESS);
        }
    }
}
// ===============================================================================
// =--------------------------------- Modules -----------------------------------=
// ===============================================================================

//Treadmaker("OUT","ADD",-10,-20,-30,1,0);
module Treadmaker(  THREADDIRECTION="INN",
                    DETERMINATOR="ADD",         //  
                    X=-10,                      //  Positio
                    Y=-20,
                    Z=-30,
                    HiggBeeEndtreatment=0,      //  higgbee on the ends 0,1,2,3 aka no higgbees,lower has,both has,upper has higgbe  
                    HIGG_BEE=0){                //  ads lenght to the Spiral, [in degree]
// ===================================================================================================================================
//                                                                    Inward
// ===================================================================================================================================
    if(THREADDIRECTION=="INN"){
        if(DETERMINATOR=="CUT"){
            difference(){
                children();
                translate([X,Y,Z]){
                    Helixiterator([ DETERMINATOR,       //=="CUT"
                                    THREADDIRECTION,    //=="INN"
                                    ThreadSpaceing,
                                    HiggBeeEndtreatment,
                                    HIGG_BEE            // if the spiral needs to be longer to cut fully through
                    ]);
                }
            }
        }
        else if(DETERMINATOR=="ADD"){
            children();
            difference(){
                translate([X,Y,Z]){
                        Helixiterator([ DETERMINATOR,       //=="ADD"
                                        THREADDIRECTION,    //=="INN"
                                        ThreadSpaceing,
                                        HiggBeeEndtreatment,
                                        HIGG_BEE            // if the spiral needs to be longer to cut fully through
                        ]);
                }
                translate([0,0,HoeheFlasche+Spacing_Lid_Can_Top]){                                                  //  Upper Cut of Thread helix
                    cylinder(h=H1_CYLINDER,d=60);
                }
                translate([0,0,HoeheFlasche-HoeheDeckel+Spacing_Lid_Can_Top-H1_CYLINDER]){                          //  Lower Cut of Thread helix // Was +TopThickness+
                    cylinder(h=H1_CYLINDER,d=60);
                }
            }
        }
        else {
            echo("ERROR on module Treadmaker() Inward"); 
        }
    }
// ===================================================================================================================================
//                                                                    Outward
// ===================================================================================================================================    
    else if(THREADDIRECTION=="OUT"){
        if(DETERMINATOR=="CUT"){
            difference(){
                children();
                difference(){
                    translate([X,Y,Z]){
                        Helixiterator([ DETERMINATOR,       //=="CUT"
                                        THREADDIRECTION,    //=="OUT"
                                        ThreadSpaceing,
                                        HiggBeeEndtreatment,
                                        HIGG_BEE            // if the spiral needs to be longer to cut fully through
                        ]);
                    }
                    translate([0,0,HoeheFlasche+Spacing_Lid_Can_Top]){               //  Upper Cut of Thread helix
                        cylinder(h=H1_CYLINDER,d=60);
                    }
                    translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top-H1_CYLINDER]){                       //  Lower Cut of Thread helix
                        cylinder(h=H1_CYLINDER,d=60);
                    }
                }
            }
        }
        else if(DETERMINATOR=="ADD"){
            children();
            difference(){
                translate([X,Y,Z]){
                        Helixiterator([ DETERMINATOR,       //=="ADD"
                                        THREADDIRECTION,    //=="OUT"
                                        ThreadSpaceing,
                                        HiggBeeEndtreatment,
                                        HIGG_BEE            // if the spiral needs to be longer to cut fully through
                        ]);
                }
                translate([0,0,HoeheFlasche]){               //  Upper Cut of Thread helix
                    cylinder(h=H1_CYLINDER,d=60);
                }
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top-H1_CYLINDER]){                       //  Lower Cut of Thread helix
                    cylinder(h=H1_CYLINDER,d=60);
                }
            }
        }
        else {
            echo("ERROR on module Treadmaker() Outward");
        }
    }
}
//Helixiterator(HelixParameterVECTOR);
module Helixiterator(X=10,Y=12,Z=0,HelixParameterVECTOR){
//TEST_HiggBee=0;   // No HiggBee cut on either ends
//TEST_HiggBee=1;   // HiggBee cut on lower end
//TEST_HiggBee=2;   // HiggBee cut on both ends
//TEST_HiggBee=3;   // HiggBee cut on upper end
    translate([X,Y,Z]){
        if (HelixParameterVECTOR[1]=="INN"){
            if (HelixParameterVECTOR[0]=="ADD"){
                //HelixParameterVECTOR=[1,1, ThreadSpaceing, CylinderSpacingCut, CylinderSpacingCutBaseCenter];
                Iterator(   HelixParameterVECTOR[2],    // Determines the Spacing of the Cut and Thread, "ThreadSpaceing"
                            0,                          // Determines wether the Spacing is applied by multipliing HelixParameterVECTOR[2] by 0 or 1
                            1,                          // Determines the Direction of the Profile (Outward/Inward)                           
                            HelixParameterVECTOR[3],    // Determines if the the HiggBee cut gets Appied
                            HelixParameterVECTOR[4]     // if the spiral needs to be longer to cut fully through
                );
                for(i=HelixParameterVECTOR){
                    echo(i,"Helixiterator_1");
                }
            }
            else if(HelixParameterVECTOR[0]=="CUT"){
                Iterator(   HelixParameterVECTOR[2],    // ...
                            1,                          // ...
                            1,                          // ...
                            HelixParameterVECTOR[3],    // ...
                            HelixParameterVECTOR[4]     // if the spiral needs to be longer to cut fully through
                );
                for(i=HelixParameterVECTOR){
                    echo(i,"Helixiterator_2");
                }
            }
        }
        else if(HelixParameterVECTOR[1]=="OUT"){
            if (HelixParameterVECTOR[0]=="ADD"){
                Iterator(   HelixParameterVECTOR[2],    // ...
                            0,                          // ...
                            0,                          // ...
                            HelixParameterVECTOR[3],    // ...
                            HelixParameterVECTOR[4]     // if the spiral needs to be longer to cut fully through
                );
                for(i=HelixParameterVECTOR){
                    echo(i,"Helixiterator_3");
                }
            }
            else if(HelixParameterVECTOR[0]=="CUT"){
                Iterator(   HelixParameterVECTOR[2],    // ...
                            1,                          // ...
                            0,                          // ...
                            HelixParameterVECTOR[3],    // ...
                            HelixParameterVECTOR[4]     // if the spiral needs to be longer to cut fully through
                );
                for(i=HelixParameterVECTOR){
                    echo(i,"Helixiterator_4");
                }
            }
        }
    }
}
//Iterator(0.125,1,0);
module Iterator(CUT_SPACING,A,DIRECTION,HiggBeeEndtreatment,ADDITIONAL_END){
    // For each step "j" there will be made two copies of the shape whith a distance of 'ARC_STEP_INCREMENT_DEGREES"
    // It encloses the shapes in hull taht becomes the "j" segment of the thread.
    // Next the "j+1" segment is createt.
    // CUT_SPACING: Creates a slightly bigger instance of the Helix Objekt for cutting to make the Thread fit (Offset on the 2D-Shape the Treadprofile is based on)
    // A [1 or 0]: Determines if the Cut Spacing is actually applied by Multipliing "CUT_SPACING" whith either 0 or 1
    // DIRECTION [1 or 0]: Determines the direktion of the thread, Outward or Inward.
    // ADDITIONAL_END: ??? 

echo("ADDITIONAL_END",ADDITIONAL_END);    
MAX_DEGREE_CALC=round(360*(H1_CYLINDER/((D1_CYLINDER*PI)*tan(ASCENT_Deg)))+ADDITIONAL_END);
echo("MAX_DEGREE_CALC",MAX_DEGREE_CALC);        
    for(k=[0:360/THREAD_COUNT:360]){
        rotate([0,0,k]){
            for(j=[0:ARC_STEP_INCREMENT_DEGREES:MAX_DEGREE_CALC-ARC_STEP_INCREMENT_DEGREES]){ // WAS: MAX_DEGREE_CALC-ARC_STEP_INCREMENT_DEGREES
                hull(){
                    Shaper(j,CUT_SPACING,HiggBee,A,DIRECTION,HiggBeeEndtreatment,MAX_DEGREE_CALC);
                    Shaper(j+ARC_STEP_INCREMENT_DEGREES,CUT_SPACING,HiggBee,A,DIRECTION,HiggBeeEndtreatment,MAX_DEGREE_CALC);
                }
            }
        }
    }
}
//Shaper(J,DELTA,HiggBee);
module Shaper(J,DELTA,HiggBee,A,DIRECTION,HiggBeeEndtreatment,MAX_DEGREE_CALC){
//HiggBeeEndtreatment=1;
//HiggBeeEndtreatment=2;
//HiggBeeEndtreatment=3;
K=0;
//echo(ASCENT_STEP,"ASCENT_STEP_2");
    rotate([0,0,-HiggBee]){
        translate([0,0,-(tan(ASCENT_Deg)*(D1_CYLINDER/2)*(((HiggBee-(HiggBee*1/6))*PI)/180))]){
            rotate([0,0,J-MAX_DEGREE_END*K]){
                translate([0,0,(J*ASCENT_STEP)]){//
                        translate([(D1_CYLINDER/2)+(DELTA*A*0),0,0]){ //-SHAPE_RADIUS // Is +(CUT_SPACING*A) nessccesary? for what exactly seems like it shifts the tooth profile one DELTA in the wrong direction so that the intended spacing is different between Outward and inward.
                            rotate([-90,0,0]){
                            //
                            if(J>=MAX_DEGREE_CALC-HiggBee && J<=MAX_DEGREE_CALC && HiggBeeEndtreatment>=1 && HiggBeeEndtreatment >= 2){ // Higbee at end of the Helix
                                scale([ (MAX_DEGREE_CALC-J)/HiggBee,
                                        (MAX_DEGREE_CALC-J+ARC_STEP_INCREMENT_DEGREES)/(HiggBee+ARC_STEP_INCREMENT_DEGREES),
                                        1   ]){
                                    3D_Base_Shape(DELTA*A,DIRECTION){
                                        Tooth_Profile(TOOTH_PROFILE);
                                    }
                                }
                            }
                            else if(J<=HiggBee && HiggBeeEndtreatment >=1 && HiggBeeEndtreatment <= 2){    // Higbee at start of the Helix
                                scale([ J/HiggBee,
                                        (J+ARC_STEP_INCREMENT_DEGREES)/(HiggBee+ARC_STEP_INCREMENT_DEGREES),
                                        1   ]){
                                    3D_Base_Shape(DELTA*A,DIRECTION){
                                        Tooth_Profile(TOOTH_PROFILE);    
                                    }
                                }
                            }
                            else{   // no Higbee on the midsection of the Helix, wouldn't make sense
                                scale([1,1,1]){
                                    //echo("3D_Base_Shape",DELTA*A);
                                    3D_Base_Shape(DELTA*A,DIRECTION){
                                        Tooth_Profile(TOOTH_PROFILE);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
//Top_Spaching_Difference_Cut(10,25,0.3,0.67,36,76);
module Top_Spaching_Difference_Cut(CANHEIGHT=45,CANDIAMETER=45,TOP_SPACING_CUT_HIGHT=1.7,SPACING_LID_CAN_CYLINDER=0.77,LOW_RESOLUTION=16, HIGH_RESOLUTION=76){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
translate([0,0,CANHEIGHT]){
    cylinder(h=TOP_SPACING_CUT_HIGHT,d=CANDIAMETER+SPACING_LID_CAN_CYLINDER);
    }    
}
//Can_to_Lid_Spaching_Difference_Cut(5,25,5,0.25,9,16,76); // $fn Resolution See vs final Render
module Can_to_Lid_Spaching_Difference_Cut(CANHEIGHT=45,CANDIAMETER=45,CANWALLTHICKNESS=5,SPACING_LID_CAN_CYLINDER=0.77,HEIGT_OF_HELIX=9,LOW_RESOLUTION=16, HIGH_RESOLUTION=76){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
translate([0,0,CANHEIGHT-HEIGT_OF_HELIX]){
    difference(){
        cylinder(h=HEIGT_OF_HELIX,d=CANDIAMETER+SPACING_LID_CAN_CYLINDER);
        cylinder(h=HEIGT_OF_HELIX,d=CANDIAMETER);
        }
    }
}
//Bottom_Spaching_Difference_Cut();
module Bottom_Spaching_Difference_Cut(){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 76
translate([0,0,CANHEIGHT]){
    cylinder(h=TOP_SPACING_CUT_HIGHT,d=CANDIAMETER+2*SPACING_LID_CAN_CYLINDER);
    }
}

//3D_Base_Shape(0,0){Tooth_Profile(TOOTH_PROFILE);}
// Creates the 3D-Object from the Toot_Profile, its a very thin Object because the followiung hull-Funktion dosent work with a 2D-Object
module 3D_Base_Shape(DELTA,DIRECTION){
    linear_extrude(height=0.1,scale=0.5){
        // makes the cut sligtly bigger to fit the parts to move smothly
        offset(delta=DELTA){ // Makes the profile sligthly bigger so parts can fit
            // Diverts the Direction of the Profile, determines if the Profile cuts in the nut (0) or the bolt (1)
            mirror([DIRECTION,0,0]){
                children();
            }    
        }
    }
}

// for testing
//TEST_OBJECT();
module TEST_OBJECT(){
    difference(){
        TEST_CUTCUBE(TestSlab_X,TestSlab_Y,TestSlab_Z);
        TEST_CUTCYLINDER();
    }
    TEST_SPHERE();
}

module TEST_CUTCUBE(X=30,Y=60,Z=15){
    cube([X,Y,Z]);
}
module TEST_SPHERE(D=TestSphere_D){
//$fn = $preview ? 12 : 72; // Facets in preview (F5) set to 12, in Reder (F6) is set to 72
    difference(){
        sphere(d=D);
        TEST_CUTCYLINDER();
    }
}
module TEST_CUTCYLINDER(H=TestCylinder_H,D1=TestCylinder_D1,D2=TestCylinder_D2){
    cylinder(h=H,d1=D1,d2=D2,$fn=24);
}
// ===============================================================================
// ---------------------------------- Cutting Modules ----------------------------
// ===============================================================================
//Screwcutter(100,10,100,4,1,5);
module Screwcutter( SCREW_HEAD_h=200,
                    SCREW_HEAD_d=40,
                    SCREW_BOLT_h=200,
                    SCREW_BOLT_d=3,
                    SCREW_CAMPFER_h,
                    SCREW_CAMPFER_d=SCREW_BOLT_d    ){
    translate([0,0,-SCREW_HEAD_h]){
        cylinder(h=SCREW_HEAD_h,d=SCREW_HEAD_d,$fn=32);
    }
    translate([0,0,0]){
        cylinder(h=SCREW_CAMPFER_h,d2=SCREW_BOLT_d,d1=SCREW_CAMPFER_d,$fn=32);    
    }
    translate([0,0,0]){
        cylinder(h=SCREW_BOLT_h,d=SCREW_BOLT_d,$fn=32);
    }
}
//Bolt(25,3,8,3);
module Bolt(BOLTLENGTH,BOLTDIAMETER,HEADDIAMETER,HEADHEIGHT){
    cylinder(h=BOLTLENGTH,d=BOLTDIAMETER,center=false,$fn=FN_Performance);
    translate([0,0,-HEADHEIGHT/2]){
        cylinder(h=HEADHEIGHT,d=HEADDIAMETER,center=true,$fn=6);
        cylinder(h=HEADHEIGHT,d=HEADDIAMETER,center=true,$fn=6);
    }
}
//Projection_Cutter(3){sphere(10);};
module Projection_Cutter(Offset_z){    
    projection(cut = true){
        translate([0,0,Offset_z]){
            children();
        }
    }
}
// ===============================================================================
// ---------------------------------- Intersection Modules -----------------------
// ===============================================================================
module Intersection_Test_Cut(PLAIN,THICKNESS,OFFSET){
// ==== EXAMPLE ====
//    !Intersection_Test_Cut("xy",1,7/2){sphere(7);};
// ==== EXAMPLE ====
    if (PLAIN=="xz"){
        intersection(){
            children();
            translate([0,OFFSET,0]){
                cube([100,THICKNESS,100],center=true);
            }
        }
    }
    else if (PLAIN=="xy") {
        intersection(){
            children();
            translate([0,0,OFFSET]){
                cube([500,500,THICKNESS],center=true);
            }
        }
    }
    else if (PLAIN=="yz") {
        intersection(){
            children();
            translate([OFFSET,0,0]){
                cube([THICKNESS,100,100],center=true);
            }
        }   
    }
}
// ===============================================================================
// ---------------------------------- Linear Extrude Modules ---------------------
// ===============================================================================

//Ring_Shaper(3,15,1.5);
module Ring_Shaper(HEIGHT,OUTER,WALLTHICKNESS){
    linear_extrude(HEIGHT){
        2D_Ring_Shape(OUTER,WALLTHICKNESS);
    }
}
//Linear_Extruding(10,-1){2D_Rounded_Square_Base_Shape(10,20,3);}
module Linear_Extruding(ExtrudeLength,ExrtudingDirektionInverter){
//   0  Normal
//  -1  inverted
//   1  
    Length=ExtrudeLength;
    translate([0,0,Length*ExrtudingDirektionInverter]){
        linear_extrude(height=ExtrudeLength){
            children();
        }
    }
}
// ===============================================================================
// ---------------------------------- Rotate Extrude Modules ---------------------
// ===============================================================================
//DONUT(1,20,1,7);
module DONUT(DIAMETER,DIAMETER_RING,SCAL_X,SCAL_Y){
//DIAMETER The dough part
//DIAMETER_RING The hole part
//SCAL_X, skales the x dimension
//SCAL_Y, skales the y dimension
    rotate_extrude(angle=360,convexity=3,$fn=FN_Fine){
        translate([DIAMETER_RING,0,0]){
            scale([SCAL_X,SCAL_Y,1]){
                circle(d=DIAMETER,$fn=FN_Fine);
            }
        }
    }
}
// ===============================================================================
// =--------------------------------- 2D-Shapes ---------------------------------=
// ===============================================================================
//Tooth_Profile("TOOTH-ON-TOOTH");
module Tooth_Profile(TOOTH_PROFILE="Trapezoid"){                           
    //polygon(points=[[-2,3],[-2,-3],[2,-1],[2,1]]);
    if (TOOTH_PROFILE=="Trapezoid"){
        // Trapezoid 1/3 vs 2 
        polygon(points=[[-1,1.5],[-1,-1.5],[1,-0.5],[1,0.5]]);
    }
    else if(TOOTH_PROFILE=="SQUARE"){
        square([1,1],center=true);
    }
    else if(TOOTH_PROFILE=="TREAD_TOOTH"){
        circle(r=SHAPE_RADIUS,$fn=4);
    }
    else if(TOOTH_PROFILE=="TOOTH-ON-TOOTH"){               // like plastic bottels have, Two oposing trapezoid tooth that glide on each other
        polygon(points=[[-1,-2],[-1,0],[1,0],[1,-0.5]]);
    }
}
//2D_Ring_Shape(20,1);
module 2D_Ring_Shape(OUTER_D,WALLTHICKNESS){
    difference(){
        circle(d=OUTER_D,$fn=FN_Fine);
        circle(d=OUTER_D-2*WALLTHICKNESS,$fn=FN_Fine);
    }
}
//2D_Rounded_Square_Base_Shape(10,20,3);
module 2D_Rounded_Square_Base_Shape(DIMENSION_X=10,DIMENSION_Y=20,RADIUS=2,CENTER=true){
    if(CENTER){
        translate([0,0,0]){
            minkowski(){
                square([DIMENSION_X-RADIUS*2,DIMENSION_Y-RADIUS*2],center=CENTER);
                circle(r=RADIUS,$fn=FN_Fine);
            }
        }
    }
    else{
        translate([RADIUS,RADIUS,0]){
            minkowski(){
                square([DIMENSION_X-RADIUS*2,DIMENSION_Y-RADIUS*2],center=CENTER);
                circle(r=RADIUS,$fn=FN_Fine);
            }
        }
    }
}
//HEX_Mesh_Pattern(){ Mesh(2.5,2.5);}
module HEX_Mesh_Pattern(X=10,Y=30,DELTA=5,GRPL_X=45,GRPL_Y=115){
Count_X=X;
Count_Y=Y;
DIMENSION_X=35;
DIMENSION_Y=67;
//DELTA=1;
X_STEPP=5.5+DELTA;
Y_STEPP=7.5+DELTA;

k=DELTA; //Distance between Hexshapes may be HEX_D/4 is good
HEX_D=(DIMENSION_X-((Count_X-1)*k/2))/(Count_X-1);
SCALE_Y=DIMENSION_Y/((HEX_D/2+k/4)*sqrt(3)*(Count_Y-1));
echo("HEX_D*Count_Y",HEX_D*(Count_Y));
echo("GrindingPlate_Y",DIMENSION_Y);
echo("SCALE_Y",SCALE_Y);
//square([15,(HEX_D/2+k/4)*sqrt(3)*(Count_Y-1)]); // Helper Foo
// +++++++++++++++++++++++++++++++++++++++++
    scale([1,SCALE_Y,1]){
        union(){
            for(j=[0:1:Count_Y-1]){
                for(i=[0:1:Count_X-1-j%2]){
                    translate([i*(HEX_D+k/2),0,0]){
                        translate([(HEX_D/2+k/4)*(j%2),
                                    j*((HEX_D/2+k/4)*sqrt(3)),
                                    0]                          ){
                        //translate([0,j*Y_STEPP,0]){
                        rotate([0,0,60]){
                            //Mesh(0.5){square([HEX_D,HEX_D*1.2],center=true);}
                            circle(d=HEX_D,$fn=6);
                        }
                            //children();
                        }
                    }
                }
            }
        }
    }
}
//Mesh(4){square([7,10],center=true);}
module Mesh(RADIUS=0.0){
minkowski(){
    children();
    circle(r=RADIUS,$fn=144);
    }
}
// ===============================================================================
// =--------------------------------- Symetrie Helper ---------------------------=
// ===============================================================================
// XY_Symetrie(10,25){cube(10);}
module XY_Symetrie(X=10,Y=25){
   translate([X,Y,0]){
       children();
       }
    mirror([1,0,0]){
        translate([X,Y,0]){
            children();
       }
    }
    mirror([0,1,0]){
        translate([X,Y,0]){
            children();
        }
        mirror([1,0,0]){
            translate([X,Y,0]){
                children();
            }
        }
    }
}
module MirrorMirrorOnTheWall(Offset_X,Offset_Y){
    translate([-Offset_X,Offset_Y,0]){
        children();
        mirror([0,1,0]){
            children();
        }
    }
    translate([Offset_X,-Offset_Y,0]){
        mirror([1,0,0]){
            children();
            mirror([1,0,0]){
                children();
            }
        }
    }
}
// ===============================================================================
// =--------------------------------- Textembossing -----------------------------=
// ===============================================================================


// ===============================================================================
// =--------------------------------- Smoothing ---------------------------------=
// ===============================================================================
2D_Smooth_r=1;
// Radius of a outer Tip Rounding 
2D_Fillet_r=1;
// Radius of a inner corner Ronding
2D_Chamfer_DELTA_INN=1;
2D_Chamfer_DELTA_OUT=2;

// a straigt line on edges and corners
2D_Chamfer_BOOLEAN=false;    
module Smooth(r=3){
    //$fn=30;
    offset(r=r,$fn=30){
        offset(r=-r,$fn=30){
        children();
        }
    }
}
module Fillet(r=3){
    //$fn=30;
    offset(r=-r,$fn=30){
        offset(r=r,$fn=30){
            children();
        }
    }
}
module Chamfer_OUTWARD(DELTA_OUT=3){
    //$fn=30;
    offset(delta=DELTA_OUT,chamfer=true,$fn=30){
        offset(delta=-DELTA_OUT,chamfer=true, $fn=30){
            children();
        }
    }
}
module Chamfer_INWARD(DELTA_INN=3){
    //$fn=30;
    offset(delta=-DELTA_INN,chamfer=true,$fn=30){
        offset(delta=DELTA_INN,chamfer=true, $fn=30){
            children();
        }
    }
}
// ===============================================================================
// =--------------------------------- Ruthex --------------------------------=
// ===============================================================================
// Dimensions for Ruthex Tread inseerts
//RUTHEX_M3();
module RUTHEX_M3(){    
L=5.7+5.7*0.25; // Length + Margin
echo("RUTHEX",L);
D1=4.0;    
    translate([0,0,0]){
        rotate([0,0,0]){
            translate([0,0,0]){
                cylinder(h=L,d1=D1,d2=D1,$fn=FN_Performance);
            }
        }
    }
}
// ===============================================================================
// =--------------------------------- Import STL --------------------------------=
// ===============================================================================
module NAME_OF_IMPORT(){
    rotate([0,0,-90]){
        translate([-515,-100,-45]){
            import("PATH/TO/FILE.stl",convexity=3);
        }
    }
}
// ===============================================================================
// =--------------------------------- Import PNG --------------------------------=
// ===============================================================================
module NAME_OF_IMPORT(){
    rotate([0,0,-90]){
        translate([-515,-100,-45]){
            import("PATH/TO/FILE.PNG",convexity=3);
        }
    }
}