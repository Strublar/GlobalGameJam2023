using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
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

    public void Retry()
    {
        GameManager.instance.Retry();
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
