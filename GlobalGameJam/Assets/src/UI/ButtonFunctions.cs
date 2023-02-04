using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonFunctions : MonoBehaviour
{
    public void StartGame()
    {
        GameManager.instance.GameOn();
    }

    public void HighScores()
    {
        Debug.Log("Highscores");
    }

    public void Exit()
    {
        
        Application.Quit();
    }

}
