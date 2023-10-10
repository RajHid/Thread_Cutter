// * Discription what the *.scad is about ect.

// ==================================
// = Used Libraries =
// ==================================

// Änderung
// Eine Zweite Änderung

// ==================================
// = Variables =
// ==================================

// sizing printing or print a small part to test the object.
DesignStatus="Tread_Dimension_CUT_Test"; //["sizing","Thread_Object_Innward","sizing_Inn_Cut","Thread_Object_Outward","sizing_Out_Cut","fitting","Tread_Dimension_CUT_Test","printing"]
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
Durchmesser_Flasche=25;
HoeheFlasche=10;
Wandstaerke_Flasche=1.5;
BottomThickness=1;
// ==== Lid ====
WandstaerkeDeckel=1.5;
HoeheDeckel=7;
TopThickness=0.7;

// ==== Helping ====
Spacing_Lid_Can_Cylinder=0.1;
Spacing_Lid_Can_Top=0.1;
rotation_Diff_Lid_Can=0;

// ==== TootProfile ====
TOOTH_PROFILE="Trapezoid"; //["Trapezoid","SQUARE","TREAD_TOOTH","TOOTH-ON-TOOTH"]


//Strings="foo"; // [foo, bar, baz]


D1_CYLINDER=Durchmesser_Flasche;
H1_CYLINDER=HoeheDeckel-TopThickness;

echo("D1_CYLINDER",D1_CYLINDER);
echo("H1_CYLINDER",H1_CYLINDER);


// === Helix Parameters ===

// Degrees the helix ascends
ASCENT_Deg=12;
// Number of Threads
THREAD_COUNT=3;
// Degrees the helixsegments the helix is made of take in each step. aka 1° will get you 360 segments the helix is made of.
ARC_STEP_INCREMENT_DEGREES=5;// Size of one subobject aka the Arc lenght of the Extrusion of the Treadprofile, the wohle Thtread gets assembled by putting them together step by step

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

MAX_DEGREE=round(360*(H1_CYLINDER/((D1_CYLINDER*PI)*tan(ASCENT_Deg)))); // --> Gets used in iterator now due to need of parametering the Start and end of the Spiral, Spiral needs to be longer to dutt fully trough
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
if (DesignStatus=="printing"){
    Main_Assembly(36,76,"false");
}
if(DesignStatus=="fitting"){
    intersection(){
        translate([0,0,1]){
            cube([1000,1000,1],center=true);
        }
        Main_Assembly(16,76,"false");
    }
}
if (DesignStatus=="sizing"){
    Main_Assembly(16,36,"true");
}
// ===============================================================================
// =----- Module to help coloring different modules to make it easier 
// ===============================================================================
// Main_Assembly(12,76,true);
// LOW_RESOLUTION: low reaulution value to speed up preview
// HIGH_RESOLUTION: high resolution value for rendering the .stl
// CUT_MODULES_RENDERED: decides if the cuttingmodules get renderred to see them. use cuttingmodules twice one time within the final part to cut and one time to just schow it.
module Main_Assembly(LOW_RESOLUTION=12,HIGH_RESOLUTION=36,CUT_MODULES_RENDERED){
$fn = $preview ? LOW_RESOLUTION : HIGH_RESOLUTION ; // Facets in preview (F5) set to 12, in Reder (F6) is set to 72
    see_me_in_colourful(){
        translate([0,0,0]){
            difference(){
                TEST_OBJECT();
                translate([25,40,15]){                    
                    scale([0.4,0.4,0.4]){        
                        TEST_CUTCUBE();
            }
        }
    }
        }
        translate([0,0,0]){
        
        }        
        translate([0,0,0]){
            difference(){
                TEST_SPHERE();
                
            }
        }
        translate([0,0,0]){
        }
        translate([0,0,0]){
            if(CUT_MODULES_RENDERED=="true"){
                TEST_CUTCYLINDER();
            }
            else{
                echo("CUT_MODULES_RENDERED= ",CUT_MODULES_RENDERED);
            }
        }
        union(){
            
        }
        translate([ 0,0,0]){
        }
    }
}
module see_me_in_colourful(){ // iterates the given modules and colors them automaticly by setting values using trigonometric funktions
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
                difference(){
                    render(convexity=10){children(i);} //renders the modules, effect is that inner holes become visible
                    //children(i);
                    translate([70/2,0,0]){
                        //cube([80,90,150],center=true);
                    }
// Creates a Cutting to see a Sidesection cut of the objects
                    color(c = [ SINUS_Foo,
                                1-(SINUS_Foo/2+COSIN_Foo/2),
                                COSIN_Foo],
                                alpha = 0.0){
                        translate([70/2,0,0]){
                            //cube([30,20,150],center=true);
                        }
                        translate([-50,-50,0]){
                            //cube([100,50,200],center=false);
                        }
                    }
                }
            }
        }
    }
}

Projection_Cutter(5){
//see_me_half();
}

//// == Cutes a slice of the Objekts
Intersection_Test_Cut("xy",1.5,16){
 //Intersection_Test_Cut( "xy",           // "Plaine xy yz xz", 
                       // 1,              // Slicethickness , 
                        //5,              // Distance from coordinate origin in plaine )
   // OBJECTMODULESHERE 
   //Frame_Base();
}

// ==================================
// = Modus =
// ==================================

 
// ==================================
// = Stage =
// ==================================
// Final module for Produktion

module Assembly(){

}
module TEST_OBJECT(){
    difference(){
        TEST_CUTCUBE(TestSlab_X,TestSlab_Y,TestSlab_Z);
        TEST_CUTCYLINDER();
    }
    TEST_SPHERE();
}

// ===============================================================================
// =--------------------------------- Enviroment Modules ------------------------=
// ===============================================================================
// Modules that resembles the Enviroment aka the helmet where to atach a camera mount


// ===============================================================================
// =--------------------------------- Modules -----------------------------------=
// ===============================================================================
//TEST_OBJECT();

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
// === Half Cutter

//HEX_Mesh_Pattern(){ Mesh(2.5,2.5);}
module HEX_Mesh_Pattern(X=10,Y=30,DELTA=5,GRPL_X=45,GRPL_Y=115){
Count_X=X;
Count_Y=Y;

//DELTA=1;

X_STEPP=5.5+DELTA;
Y_STEPP=7.5+DELTA;

k=DELTA; //Distance between Hexshapes may be HEX_D/4 is good
HEX_D=(GrindingPlate_X-((Count_X-1)*k/2))/(Count_X-1);

SCALE_Y=GrindingPlate_Y/((HEX_D/2+k/4)*sqrt(3)*(Count_Y-1));
echo("HEX_D*Count_Y",HEX_D*(Count_Y));
echo("GrindingPlate_Y",GrindingPlate_Y);
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
//Mesh(5,2);
module Mesh(SHAPEDIMENSION_X=2.5,RADIUS=0.0){
minkowski(){
    circle(SHAPEDIMENSION_X-RADIUS,$fn=6);
    //circle(r=RADIUS,$fn=64);
    }
    //circle(SHAPEDIMENSION_X,$fn=6); // Size Testing
}
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