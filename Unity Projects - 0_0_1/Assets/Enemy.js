#pragma strict


// Enemy Controller
// Description: Control component enemy logic, options and properties
	
var moveSpeed 		: float 	= 20.0;	 // set the speed of the enemy
var attackMoveSpeed : float 	= 35.0;	 // set the speed for attack range
var jumpSpeed 		: float 	= 3.0; 	 // set the jump height
	
enum EnemyState { moveLeft = 0, moveRight = 1, moveUp = 2, moveDown = 3, moveStop = 4, jumpAir = 5, enemyDie = 6, goHome = 7 }
var enemyState = EnemyState.moveLeft; 	 // set the starting state

var attackRange		: float 	= 1.0; 	 // set the range for the attackMoveSpeed attack/movement speed
var searchRange 	: float 	= 3.0; 	 // set the range for finding the player
var returnHome   	: float 	= 4.0; 	 // set leashing distance
	
var chaseTarget 	: Transform; 		 // load up the player target
var homePosition 	: Transform; 		 // load up the home position
var deathForce 		: float 	= 3.0; 	 // when the player jumps on me force him off 'x' amount
	
var gizmoToggle 	: boolean = true; 	 // toggle the display of the debug radius
	
private var velocity 		 : Vector3 = Vector3.zero; 	// store the player movement in velocity (x, y)
private var gravity 		 : float = 20.0; 			// weight of the world pushing the enemy down
private var currentState;								// hold the current state for setting later
private var aniPlay;									// get the component for animations
private var isRight 		 : boolean = false;			// setting the direction
private var myTransform 	 : Vector3;					// store initial position
private var resetMoveSpeed   : float = 0.0;				// store the initial move speed
private var distanceToHome   : float = 0.0;				// get the distance to the inital move position
private var distanceToTarget : float = 0.0;				// get distance to the target position
private var controller 		 : CharacterController; 	// get controller 



var animator : Animator;


function Start () 
{	
	myTransform = transform.position;
	resetMoveSpeed = moveSpeed;
	controller = GetComponent (CharacterController);

//	linkToPlayerProperties = GetComponent(playerProperties);  // This links to player properties which includes (lives, states, etc)
//	aniPlay = GetComponent (aniSprite); // Some sort of animation sprite thing, possibly linked to the player

	animator = GetComponent("Animator");	
}	
	
function Update () 
{
	if(controller.isGrounded)	
	{
		switch (enemyState)
		{
			case EnemyState.moveLeft :
			PatrolLeft ();
			animator.SetInteger("Direction", 0);
			break; 	
			
			case EnemyState.moveRight :
			PatrolRight ();
			animator.SetInteger("Direction", 1);
			break; 	
			
			case EnemyState.moveUp :
			PatrolUp ();
			animator.SetInteger("Direction", 2);
			break; 	
			
			case EnemyState.moveDown :
			PatrolDown ();
			animator.SetInteger("Direction", 3);
			break; 
			
			case EnemyState.moveStop :
			IdleRight ();
			break; 	
			
			case EnemyState.jumpAir :
			JumpRight ();
			break; 	
			
			case EnemyState.enemyDie :
			DieRight ();
			break; 		
			
			case EnemyState.goHome :
			GoHome ();
			break;										
		}
	}
	//Apply gravity
	velocity.y -= gravity * Time.deltaTime;			// apply the gravity
	// move the controller
	controller.Move (velocity * Time.deltaTime); 	// move the controller
}

function OnTriggerEnter (other : Collider)
{

}
// move the enemy right
function PatrolRight ()
{
	velocity.x = moveSpeed * Time.deltaTime;
	animator.SetInteger("Direction", 0);
}

// move the enemy left
function PatrolLeft ()
{
	velocity.x = -moveSpeed * Time.deltaTime;		// move the controller to the left	
	animator.SetInteger("Direction", 1);
}

// move the enemy up
function PatrolUp ()
{
	velocity.y = -moveSpeed * Time.deltaTime;		// move the controller to the left	
	animator.SetInteger("Direction", 2);
}

// move the enemy down
function PatrolDown ()
{
	velocity.y = moveSpeed * Time.deltaTime;		// move the controller to the left	
	animator.SetInteger("Direction", 3);
}

// set movement to 0 and face right
function IdleRight ()
{

}

// set movement to 0 and face left
function IdleLeft ()
{

}

// jumps in the air to the right
function JumpRight ()
{

}

// jumps in the air to the left
function JumpLeft ()
{

}

// kill the enemy right
function DieRight ()
{ 

}

// kill enemy left
function DieLeft ()
{

}

// check for where the player is in relation to our position
function ChasePlayer ()
{

}

// finds the home node and returns to it
function GoHome ()
{

}

// toggle the gizmos for the designer to see ranges
function OnDrawGizmos ()
{

}

private class ShushES {var q:Queue; var h:Help; var g:GUI;}


























