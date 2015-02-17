
#include "colors.inc"
#include "functions.inc"    
#include "shapes.inc"   

camera {
   location <7, 2,-10>
   look_at <3,2,1.5> 
}                                                           

light_source { <0, 10, 1.5> color White shadowless}
light_source {<100,200,-300> rgb <1, 1, 1> shadowless}
plane{<0, 1, 0>, 0 pigment{White}}    
    
 
/*#declare frontU = union{   
         box{<1.5,1,0>, <3.5,2,3> pigment{Grey}}
         box{<2.5,1.5,-0.000001>, <3.5,2,3.000001> pigment{Black}}
}   */
/*#declare frontI = intersection{   
         box{<1.5,1,0>, <3.5,2,3> pigment{Grey}}
         box{<2.5,1.5,0>, <3.5,2,3> pigment{Black}}
} */                                            
#declare frontD = difference{   
        box{<2.05,1,0>, <3.55,2.5,3> pigment{Grey}}
        box{<2.8,1.75,0>, <3.55,2.5,3> pigment{Clear}}
             
}  

#declare wheel = union{
        cylinder{ <-3,.5,0>,<-3,.5,0.5>, 0.5 pigment{Black}}
        cylinder{ <-3,.5,-.005>,<-3,.5,.0505>, 0.1 pigment{White}}
}

#declare cab = union{ 
        
        union{
        object{frontD}  
        
        difference{
                        cylinder{ 
                                <2.8,1.75,0.05> <2.8,1.75,2.95> .75
                                  
                                pigment{ rgbf <1.0,1.0,1.0,0.75> }
                                finish{phong 0.9 phong_size 3 reflection 0.2}
                        }
                        object{frontD}       
                }
        }    
        object{wheel translate<6.05,0,0>}
        object{wheel translate<6.05,0,2.5>} 
}

 
#declare carriage = union{
        box{<-4,1,0>, <2,3,3> pigment{Grey}}
        object{wheel}
        object{wheel translate <0,0,2.5>}
        object{wheel translate <4,0,0>}
        object{wheel translate <4,0,2.5>}    
}

#declare truck = union{
        object{carriage}
        object{cab} 
        box{<2,1.05,0.2> <2.2,1.2,2.8> pigment{Grey}}
}        

object{truck translate<clock,0,0>}
        
