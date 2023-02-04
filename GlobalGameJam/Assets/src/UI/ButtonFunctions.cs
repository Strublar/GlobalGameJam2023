using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonFunctions : MonoBehaviour
{
    public void StartGame()
    {
        SceneManager.LoadScene("MainScene");
    }
    
    public void ResumeGame()
    {
        GameManager.instance.ToggleMainMenu();
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
