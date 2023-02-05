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
    

    [SerializeField] private int boostThreshold;
    

    private int _score;
    private int consecutiveHits;
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
        GameOn();
    }

    public void Death()
    {
        Time.timeScale = 0;
        deathCanvas.enabled = true;
        _score = 0;
    }

    public void DoBeat()
    {
        if (!hasHitLastBeat)
        {
            consecutiveHits = 0;
        }
        hasHitLastBeat = false;
    }

    #endregion

    public void IncrementScore(int scoreAmount)
    {
        _score += scoreAmount;
        if (scoreAmount != 0)
        {
            hasHitLastBeat = true;
            consecutiveHits += 1;
            scoreTxt.color = GetColorForConsecutiveHits(consecutiveHits);
            handlePowerUp(consecutiveHits);
        }

        ShakeCameraAccordingToScoreIncrease(scoreAmount);
        scoreTxt.text = _score.ToString();
    }

    private void handlePowerUp(int consecutiveHits)
    {
        if (consecutiveHits >= boostThreshold)
        {
            Debug.Log("ALMIGHT ACTIVATED");
            // player.
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
        if (scoreAmount == 0)
        {
            return;
        }

        var shakeScore = shakeCoeff * scoreAmount;
        var shakeVector = new Vector3(shakeScore, shakeScore, shakeScore);
        if (shakeDuration > 0)
        {
            Camera.main.DOShakePosition(shakeDuration, shakeVector, 20, 45f, false, ShakeRandomnessMode.Harmonic);
        }
    }
}