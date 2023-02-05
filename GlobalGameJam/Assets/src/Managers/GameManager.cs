using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    [SerializeField] private GameObject cameraObj;
    [SerializeField] private float shakeCoeff;
    [SerializeField] private float shakeDuration;
    [SerializeField] private Canvas mainMenuCanvas;
    [SerializeField] private Canvas deathCanvas;
    [SerializeField] private TextMeshProUGUI scoreTxt;
    [SerializeField] private AudioSource audioBeat;
    [SerializeField] private Player player;
    [SerializeField] private BeatManager beatManager;
    

    [SerializeField] private int boostThreshold;
    [SerializeField] private int boostScoreAmount;


    private int _score;
    private int consecutiveHitsForVisual;
    private int consecutiveHitsForBoost;

    private bool hasHitLastBeat;


    private void Awake()
    {
        instance = this;
        mainMenuCanvas.enabled = false;
        deathCanvas.enabled = false;
    }


    void Start()
    {
        scoreTxt.text = _score.ToString();
        GameOn();
    }

    #region UI utilities

    public void ToggleMainMenu()
    {
        mainMenuCanvas.enabled = !mainMenuCanvas.enabled;
        if (Time.deltaTime == 0)
        {
            Time.timeScale = 1;
        }
        else
        {
            Time.timeScale = 0;
        }
    }

    public void GameOn()
    {
        beatManager.Init();
        Time.timeScale = 1;
        mainMenuCanvas.enabled = false;
        audioBeat.loop = true;
        audioBeat.Play();
    }

    public void Retry()
    {
        LoadMainScene();
    }

    public void LoadMainScene()
    {
        SceneManager.LoadScene("MainScene", LoadSceneMode.Single);
    }

    public void Death()
    {
        //Time.timeScale = 0;
        deathCanvas.enabled = true;
        deathCanvas.GetComponent<Animator>().enabled = true;
        _score = 0;
    }

    public void DoBeat()
    {
        if (!hasHitLastBeat)
        {
            ResetConsecutiveHits();
        }

        hasHitLastBeat = false;
    }

    #endregion

    public void IncrementScore(int scoreAmount)
    {
        if (scoreAmount == 0)
        {
            return;
        }

        _score += scoreAmount;
        hasHitLastBeat = true;
        IncrementConsecutiveHits();
        handlePowerUp(consecutiveHitsForBoost);
        HandleVisualsForScore(scoreAmount);
    }

    private void IncrementConsecutiveHits()
    {
        consecutiveHitsForVisual += 1;
        consecutiveHitsForBoost += 1;
    }

    private void ResetConsecutiveHits()
    {
        consecutiveHitsForVisual = 0;
        consecutiveHitsForBoost = 0;
    }

    public void IncrementScoreWhileOnPowerUp(int wallCountDestroyed)
    {
        IncrementScore(boostScoreAmount * wallCountDestroyed);
        consecutiveHitsForBoost = 0;
        player.ResetAlmightyScissors();
    }

    private void HandleVisualsForScore(int scoreAmount)
    {
        scoreTxt.color = GetColorForConsecutiveHits(consecutiveHitsForVisual);
        ShakeCameraAccordingToScoreIncrease(scoreAmount);
        scoreTxt.text = "Score : " + _score;
    }

    private void handlePowerUp(int consecutiveHitsForBoost)
    {
        if (consecutiveHitsForBoost >= boostThreshold)
        {
            player.SetAlmightyScissors();
        }
    }

    private static Color GetColorForConsecutiveHits(int consecutiveHits)
    {
        if (consecutiveHits <= 1)
        {
            return Color.black;
        }

        if (consecutiveHits <= 3)
        {
            return Color.yellow;
        }

        return Color.red;
    }

    private void ShakeCameraAccordingToScoreIncrease(int scoreAmount)
    {
        var shakeScore = shakeCoeff * scoreAmount;
        var shakeVector = new Vector3(shakeScore, shakeScore, shakeScore);
        if (shakeDuration > 0)
        {
            Camera.main.DOShakePosition(shakeDuration, shakeVector, 20, 45f, false, ShakeRandomnessMode.Harmonic);
        }
    }
}