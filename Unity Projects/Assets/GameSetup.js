#pragma strict

var mainCam : Camera;
var topWall : BoxCollider2D;
var bottomWall : BoxCollider2D;
var leftWall : BoxCollider2D;
var rightWall : BoxCollider2D;

var Player01 : Transform;
var Player02 : Transform;

function Update () {
	topWall.size = new Vector2 (mainCam.ScreenToWorldPoint (new Vector3 (Screen.width * 2f, 0f, 0f)).x, 1f);
	topWall.center = new Vector2 (0f, mainCam.ScreenToWorldPoint (new Vector3 (0f, Screen.height, 0f)).y - 4f);

	bottomWall.size = new Vector2 (mainCam.ScreenToWorldPoint (new Vector3 (Screen.width * 2f, 0f, 0f)).x, 1f);
	bottomWall.center = new Vector2 (0f, mainCam.ScreenToWorldPoint (new Vector3 (0f, 0f, 0f)).y - 0.5f);
	
	//Player01.position.x = mainCam.ScreenToWorldPoint (new Vector3 (75f,0f,0f)).x;
	//Player02.position.x = mainCam.ScreenToWorldPoint (new Vector3 (Screen.width - 75f,0f,0f)).x;
}