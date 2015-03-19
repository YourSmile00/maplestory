HPDATA = {
     {--head
        files = {
            "front.head.png",
            "back.head.png"
        },
        states = {
            {--stand
                indexes = {1,1,1,1,1},
                positions = {{x=2.5,y=46},{x=3,y=46},{x=3.5,y=46},
                {x=3,y=46},{x=2.5,y=46}}
            },
            {--walk
                indexes = {1,1,1,1,1},
                positions = {{x=2,y=46},{x=2,y=45.5},{x=2,y=46},
                    {x=2,y=45.5},{x=2,y=46}}
            },
            {--jump
                indexes = {1},
                positions = {{x=1,y=44}}
            }
        } 
    },
    {--face
        files={
            "default.face.png"
        },
        states = {
            {--stand
                indexes = {1,1,1,1,1},
                positions = {{x=-1.5,y=40},{x=-1,y=40},{x=-.5,y=40},
                    {x=-1,y=40},{x=-1.5,y=40}}
            },
            {--walk
                indexes = {1,1,1,1,1},
                positions = {{x=-2,y=40},{x=-2,y=39.5},{x=-2,y=40},
                    {x=-2,y=39.5},{x=-2,y=40}}
            },
            {--jump
                indexes = {1},
                positions = {{x=-3,y=38}}
            }
        }
    },
    {--body
        files={
            "stand1.0.body.png",
            "stand1.1.body.png",
            "stand1.2.body.png",
            "walk1.0.body.png",
            "walk1.1.body.png",
            "walk1.2.body.png",
            "walk1.3.body.png",
            "jump.0.body.png"
       },
       states = {
            {--stand
                indexes = {1,2,3,2,1},
                positions = {{x=0,y=15.5},{x=0,y=15.5},{x=0,y=15.5},
                    {x=0,y=15.5},{x=0,y=15.5}}
            },
            {--walk
                indexes = {4,5,6,7,4},
                positions = {{x=0,y=16},{x=2.5,y=16},{x=-1.5,y=16},
                    {x=-0.5,y=16},{x=0,y=16}}
            },
            {--jump
                indexes = {8},
                positions = {{x=0,y=15}}
            }
       }
    },
    {--arm
        files={
            "stand1.0.arm.png",
            "stand1.1.arm.png",
            "stand1.2.arm.png",
            "walk1.0.arm.png",
            "walk1.1.arm.png",
            "walk1.2.arm.png",
            "walk1.3.arm.png",
            "jump.0.arm.png"
            },
        states = {
            {--stand
               indexes = {1,2,3,2,1},
                positions = {{x=10,y=20},{x=11.5,y=20},{x=12.5,y=20},
                    {x=11.5,y=20},{x=10,y=20}} 
            },
            {--walk
                indexes = {4,5,6,7,4},
                positions = {{x=11.5,y=21.5},{x=5.5,y=20},{x=11.5,y=21.5},
                    {x=12.5,y=22},{x=11.5,y=21.5}}
            },
             {--jump
                indexes = {8},
                positions = {{x=6.5,y=24.5}}
            }
        }
    }
}

