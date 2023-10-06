// * Discription what the *.scad is about ect.

// ==================================
// = Used Libraries =
// ==================================


// ==================================
// = Variables =
// ==================================

// sizing printing or print a small part to test the object.
DesignStatus="Tread_Dimension_CUT_Test"; // ["sizing","Thread_Object_Innward","sizing_Inn_Cut","Thread_Object_Outward","sizing_Out_Cut","fitting","Tread_Dimension_CUT_Test","printing"]
// "sizing": 
//  "Thread_Object_Innward":
////    
//
//  "sizing_Inn_Cut":
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

// =================

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
HiggBee=ARC_STEP_INCREMENT_DEGREES*6;


// The Screw head diameter
ScrewMount_D=15;
// The Height of the Screw head
Screw_Head_H=2.5;

module __Customizer_Limit__ () {}  // bevfore these the variables are usable in the cutomizer
shown_by_customizer = false;
// === Variations of Trads ===

// ====== Innward ====

// ========= Lid =====
/*
    Tread Parameter:
        * ADD
        * Tread_Spacing             No
        * Open side:
            Higgbee Cut Applied     Yes
            
        * Closed side:
            Higgbee Cut Applied:    No
            
*/
// ========= Can =====
/*
    Tread Parameter:
        * CUT
        * Tread Spacing             Yes
        * Open side:
            Higgbee Cut Applied:    No
            
        * Closed side:
            Higgbee Cut Applied     Yes
*/
// ====== Outward ====

// ========= Lid =====

// ========= Can =====

//// ==== Thread on Thread ====


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

// ==================================
// = Tuning Variables =
// ==================================
// Variables for finetuning (The Slegehammer if something has to be made fit)

// ==================================
// = Test Stage =
// ==================================
// BLUEPRINT_Enviroment
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
// BLUEPRINT_Enviroment
if (DesignStatus=="printing"){
    //TEST_OBJECT(FN_ExtraFine);
}
// BLUEPRINT_Enviroment
if(DesignStatus=="fitting"){
    intersection(){
        TEST_OBJECT(FN_FACETTES=FN_MediumRough);
        cube([200,200,1],center=true);
    }
    //TEST_OBJECT(FN_FACETTES=FN_MediumRough);
}
// Beta
if (DesignStatus=="sizing"){
    see_me_half(){
        translate([0,0,0]){
            //TEST_OBJECT(FN_Rough);
            Treadmaker("INN","CUT",0,0,HoeheFlasche-HoeheDeckel+Wandstaerke_Flasche){
                Can();
            }
        }
        translate([0,0,HoeheFlasche-HoeheDeckel+WandstaerkeDeckel]){
            //Lid();
        }
        translate([0,0,0]){
        
        }        
        translate([0,0,0]){
            
        }
        translate([0,0,Wandstaerke_Flasche]){
            Treadmaker("INN","ADD",0,0,HoeheFlasche-HoeheDeckel){
                translate([0,0,HoeheFlasche-HoeheDeckel]){
                    Lid();
                }
            }
        }
        translate([0,0,0]){

        }
        translate([0,0,0]){
            //TEST_CUTCUBE();
        }
        union(){
            //TEST_CUTCYLINDER(FN_Rough);
        }
        translate([ 0,0,0]){

        }
    }
}

// ---------------------------------------------------------------------------------------------------------
// --------------                          Thread_Object_Outward                              --------------
// ---------------------------------------------------------------------------------------------------------
if (DesignStatus=="Thread_Object_Innward"){
    see_me_half(){
        translate([0,0,0]){
        //Tooth_Profile();
        }
        union(){ // A single step element the Thread gets assembled of 
            hull(){
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES]){
                    translate([0,Durchmesser_Flasche/2,Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }//ASCENT_STEP
                }
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }
                }
            }
        }
        union(){ // A second single step element the Thread gets assembled of 
            hull(){
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }//ASCENT_STEP
                }
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*3]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+2*ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }
                }
            }
        }
        translate([0,0,Wandstaerke_Flasche]){
            Treadmaker("INN","ADD",0,0,HoeheFlasche-HoeheDeckel){
                //translate([0,0,HoeheFlasche-HoeheDeckel]){
                    //Lid();
                //}
            }
        }
    }
}
// Innward_Configuration
if (DesignStatus=="sizing_Inn_Cut"){
    see_me_half(){
        translate([0,0,0]){
            //TEST_OBJECT(FN_Rough);
            !Treadmaker( "INN",  //  THREADDIRECTION
                        "CUT",  //  DETERMINATOR="ADD"
                        0,      //  X
                        0,      //  Y
                        HoeheFlasche-HoeheDeckel+BottomThickness,   //  Z
                        1,      //  HiggBeeEndtreatment, Vector 0,1,2,3
                        HiggBee //  =ARC_STEP_INCREMENT_DEGREES*6;
                        ){
                Can();
            }
        }
        translate([0,0,0]){
            Treadmaker( "INN",  //  THREADDIRECTION
                        "ADD",  //  DETERMINATOR="ADD"
                        0,      //  X
                        0,      //  Y
                        HoeheFlasche-HoeheDeckel+BottomThickness,   //  Z
                        1,       //  HiggBeeEndtreatment, Vector 0,1,2,3
                        HiggBee //  =ARC_STEP_INCREMENT_DEGREES*6;
                        ){
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top]){
                    Lid();
                }
            }
        }
    }
}
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++                          Thread_Object_Outward                              ++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (DesignStatus=="Thread_Object_Outward"){
    see_me_half(){
        translate([0,0,0]){
        Tooth_Profile();
        }
        union(){ // A single step element the Thread gets assembled of 
            hull(){
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES]){
                    translate([0,Durchmesser_Flasche/2,Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }//ASCENT_STEP
                }
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }
                }
            }
        }
        union(){ // A second single step element the Thread gets assembled of 
            hull(){
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }//ASCENT_STEP
                }
                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*3]){
                    translate([ 0,
                                Durchmesser_Flasche/2,
                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+2*ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
                        rotate([-90,0,-90]){
                        3D_Base_Shape(0,0){Tooth_Profile();}
                        }
                    }
                }
            }
        }
        translate([0,0,Wandstaerke_Flasche]){
            Treadmaker("OUT","ADD",0,0,HoeheFlasche-HoeheDeckel){
                //translate([0,0,HoeheFlasche-HoeheDeckel]){
                    //Lid();
                //}
            }
        }
    }
}
// Outward_Configuration
if (DesignStatus=="sizing_Out_Cut"){
    see_me_half(){
        translate([0,0,0]){
            //TEST_OBJECT(FN_Rough);
            Treadmaker( "OUT",
                        "ADD",
                        0,
                        0,
                        HoeheFlasche-HoeheDeckel+BottomThickness,
                        2,
                        HiggBee*1 //  =ARC_STEP_INCREMENT_DEGREES*6
                        ){
                //Can();
            }
        }
        translate([0,0,0]){
            Treadmaker( "OUT",
                        "CUT",
                        0,
                        0,
                        HoeheFlasche-HoeheDeckel+BottomThickness,
                        3,
                        HiggBee*1 //  =ARC_STEP_INCREMENT_DEGREES*6
                        ){ 
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top]){
                    Lid();
                }
            }
        }
        translate([0,0,0]){

        }
        translate([0,0,0]){
            //TEST_CUTCUBE();
        }
        union(){
            //TEST_CUTCYLINDER(FN_Rough);
        }
        translate([ 0,0,0]){

        }
    }
}
//"Tread_Dimension_CUT_Test"
if (DesignStatus=="Tread_Dimension_CUT_Test"){
    see_me_half(){
        translate([0,0,0]){
        Tooth_Profile();
        }
//        union(){ // A single step element the Thread gets assembled of 
//            hull(){
//                rotate([0,0,ARC_STEP_INCREMENT_DEGREES]){
//                    translate([0,Durchmesser_Flasche/2,Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel]){
//                        rotate([-90,0,-90]){
//                        3D_Base_Shape(0,0){Tooth_Profile();}
//                        }
//                    }//ASCENT_STEP
//                }
//                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
//                    translate([ 0,
//                                Durchmesser_Flasche/2,
//                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
//                        rotate([-90,0,-90]){
//                        3D_Base_Shape(0,0){Tooth_Profile();}
//                        }
//                    }
//                }
//            }
//        }
//        union(){ // A second single step element the Thread gets assembled of 
//            hull(){
//                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*2]){
//                    translate([ 0,
//                                Durchmesser_Flasche/2,
//                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
//                        rotate([-90,0,-90]){
//                        3D_Base_Shape(0,0){Tooth_Profile();}
//                        }
//                    }//ASCENT_STEP
//                }
//                rotate([0,0,ARC_STEP_INCREMENT_DEGREES*3]){
//                    translate([ 0,
//                                Durchmesser_Flasche/2,
//                                Wandstaerke_Flasche+HoeheFlasche-HoeheDeckel+2*ARC_STEP_INCREMENT_DEGREES*ASCENT_STEP]){
//                        rotate([-90,0,-90]){
//                        3D_Base_Shape(0,0){Tooth_Profile();}
//                        }
//                    }
//                }
//            }
//        }
        translate([0,0,0]){
            Treadmaker("OUT","ADD",0,0,HoeheFlasche-HoeheDeckel,3){
                //translate([0,0,HoeheFlasche-HoeheDeckel]){
                    //Lid();
                //}
            }
        }
        translate([0,0,0]){
            Lid();
        }
    }
}
// ================================================================================================================================================
//
// ================================================================================================================================================
// BLUEPRINT_Enviroment
module see_me_half(){
    //difference(){
        //union(){
          translate([0,0,0]){
            for(i=[0:1:$children-1]){
                a=255;
                b=50;
                k_farbabstand=((a-b)/$children);
                Farbe=((k_farbabstand*i)/255);
                SINUS_Foo=0.5+(sin(((360/(a-b))*k_farbabstand)*(i+1)))/2;
                COSIN_Foo=0.5+(cos(((360/(a-b))*k_farbabstand)*(i+1)))/2;
                color(c = [ SINUS_Foo,
                            1-(SINUS_Foo/2+COSIN_Foo/2),
                            COSIN_Foo],
                            alpha = 0.5){  
                    //MirrorMirrorOnTheWall(0){
                    difference(){
                        //MirrorMirrorOnTheWall(0){
                            render(convexity=20){children(i);}
                            //children(i);
                        //}
// Creates a Cutting to see a Sidesection cut of the objects
                            color(c = [ SINUS_Foo,
                                1-(SINUS_Foo/2+COSIN_Foo/2),
                                COSIN_Foo],
                                alpha = 0.2){
                                translate([70/2,0,0]){
                                    //cube([70,70,150],center=true);
                                }
                                translate([5,0,0]){
                                    //cube([60,60,HoeheFlasche+HoeheDeckel],center=false);
                                    //#cube([30,30,200],center=true);
                                    }
                                }
                                translate([0,5,0]){
                                    //cube([60,60,HoeheFlasche+HoeheDeckel],center=false);
                                }
                                rotate([0,0,20]){
                                    Arc_CUT(35);
                                }    
                            }
                        }
                    }
                    //MAIN_AXIS_ARRANGEMENT();
                } // sin((2*PI*i)/$children)
            }
// == Testprints ==
//Arc_CUT();
module Arc_CUT(D){
    //square([1,1]);
    linear_extrude([0,0,50]){
        hull(){
            //polygon(points=[[1,1]]);
            //translate([1,1,0]){circle(d=0.0001);}
            //polygon(points=[[0,0],[1,0],[0,1]]);
            circle(d=0.0001);
            translate([30,30,0]){
                circle(r=D);
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
module TEST_OBJECT(FN_FACETTES){
    difference(){
        TEST_CUTCUBE();
        TEST_CUTCYLINDER(FN_FACETTES);
    }
}

// ===============================================================================
// =--------------------------------- Enviroment Modules ------------------------=
// ===============================================================================
// Modules that resembles the Enviroment aka the helmet where to atach a camera mount


// ===============================================================================
// =--------------------------------- Modules -----------------------------------=
// ===============================================================================
//TEST_OBJECT();

//                // ==== Can ====
//                Durchmesser_Flasche=50;
//                HoeheFlasche=25;
//                Wandstaerke_Flasche=5;
//                BottomThickness=5;
//                // ==== Lid ====
//
//                WandstaerkeDeckel=3;
//                HoeheDeckel=25;
//                TopThickness=3;
//
//                // =================
//
//                D1_CYLINDER=Durchmesser_Flasche;
//                H1_CYLINDER=HoeheDeckel-WandstaerkeDeckel*2;

//Spacing_Lid_Can_Cylinder=0.1;
//Spacing_Lid_Can_Top=0.1;
//rotation_Diff_Lid_Can=0;


module TEST_CUTCUBE(){
    cube([50,100,30]);
}
//Lid();
module Lid(){
    translate([0,0,0]){
        difference(){
            cylinder(h=HoeheDeckel,d=Durchmesser_Flasche+2*WandstaerkeDeckel,$fn=FN_FACETETTES_NUMBER);
            translate([0,0,-TopThickness]){
                cylinder(h=HoeheDeckel,d=Durchmesser_Flasche+2*Spacing_Lid_Can_Cylinder,$fn=FN_FACETETTES_NUMBER);
            }
        }
    }
}
//Can();
module Can(){
    difference(){
        cylinder(h=HoeheFlasche,d=Durchmesser_Flasche,$fn=FN_FACETETTES_NUMBER);
        translate([0,0,BottomThickness]){
            cylinder(h=HoeheFlasche,d=Durchmesser_Flasche-2*Wandstaerke_Flasche,$fn=FN_FACETETTES_NUMBER);
        }
    }
}
module Treadmaker(THREADDIRECTION="INN",DETERMINATOR="ADD",X=-10,Y=-20,Z=-30,HiggBeeEndtreatment=0,HIGG_BEE){
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
                translate([0,0,HoeheFlasche+Spacing_Lid_Can_Top]){               //  Upper Cut of Thread helix
                    cylinder(h=H1_CYLINDER,d=60);
                }
                translate([0,0,HoeheFlasche-HoeheDeckel+TopThickness+Spacing_Lid_Can_Top-H1_CYLINDER]){                       //  Lower Cut of Thread helix
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
module Helixiterator(HelixParameterVECTOR){
//TEST_HiggBee=0;   // No HiggBee cut on either ends
//TEST_HiggBee=1;   // HiggBee cut on lower end
//TEST_HiggBee=2;   // HiggBee cut on both ends
//TEST_HiggBee=3;   // HiggBee cut on upper end
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

//Iterator(0.125,1,0);
module Iterator(CUT_SPACING,A,DIRECTION,HiggBeeEndtreatment,ADDITIONAL_END){
    // For each step "j" there will be made two copies of the shape whith a distance of 'ARC_STEP_INCREMENT_DEGREES"
    // It encloses the shapes in hull taht becomes the "j" segment of the thread.
    // Next the "j+1" segment is createt.
    // CUT_SPACING: Creates a slightly bigger instance of the Helix Objekt for cutting to make the Thread fit (Offset on the 2D-Shape the Treadprofile is based on)
    // A [1 or 0]: Determines if the Cut Spacing is actually applied by Multipliing "CUT_SPACING" whith either 0 or 1
    // DIRECTION [1 or 0]: Determines the direktion of the thread, Outward or Inward.
    
//    
MAX_DEGREE_CALC=round(360*(H1_CYLINDER/((D1_CYLINDER*PI)*tan(ASCENT_Deg)))+ADDITIONAL_END);
echo("MAX_DEGREE_CALC",MAX_DEGREE_CALC);    
//    
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
                                        Tooth_Profile();
                                    }
                                }
                            }
                            else if(J<=HiggBee && HiggBeeEndtreatment >=1 && HiggBeeEndtreatment <= 2){    // Higbee at start of the Helix
                                scale([ J/HiggBee,
                                        (J+ARC_STEP_INCREMENT_DEGREES)/(HiggBee+ARC_STEP_INCREMENT_DEGREES),
                                        1   ]){
                                    3D_Base_Shape(DELTA*A,DIRECTION){
                                        Tooth_Profile();    
                                    }
                                }
                            }
                            else{   // no Higbee on the midsection of the Helix, wouldn't make sense
                                scale([1,1,1]){
                                    //echo("3D_Base_Shape",DELTA*A);
                                    3D_Base_Shape(DELTA*A,DIRECTION){
                                        Tooth_Profile();
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
//3D_Base_Shape(0,0){Tooth_Profile();}
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
// ===============================================================================
// ---------------------------------- Cutting Modules ----------------------------
// ===============================================================================
// === Half Cutter

module TEST_CUTCYLINDER(FN_FACETTES){
    cylinder(h=35,d1=55,d2=75,$fn=FN_FACETTES);
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

module Linear_Extruding(ExtrudeLength,ExrtudingDirektionInverter){
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
//Tooth_Profile();
module Tooth_Profile(){
    //polygon(points=[[-2,3],[-2,-3],[2,-1],[2,1]]);
    polygon(points=[[-1,1.5],[-1,-1.5],[1,-0.5],[1,0.5]]);
    //square([1,1],center=true);
    //circle(r=SHAPE_RADIUS,$fn=6);
    //polygon(points=[[-2,-4],[-2,0],[2,0],[2,-1]]);
}

//2D_Ring_Shape(20,1);
module 2D_Ring_Shape(OUTER_D,WALLTHICKNESS){
    difference(){
        circle(d=OUTER_D,$fn=FN_Fine);
        circle(d=OUTER_D-2*WALLTHICKNESS,$fn=FN_Fine);
    }
}
//2D_Rounded_Square_Base_Shape(10,20,3);
module 2D_Rounded_Square_Base_Shape(DIMENSION_X=10,DIMENSION_Y=20,RADIUS=2){
    translate([RADIUS,RADIUS,0]){
        minkowski(){
            square([DIMENSION_X-RADIUS*2,DIMENSION_Y-RADIUS*2]);
            circle(r=RADIUS,$fn=FN_Fine);
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
