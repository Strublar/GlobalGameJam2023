using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class BeatManager : MonoBehaviour
{
    public static UnityEvent Beat = new UnityEvent();
    public static UnityEvent OffBeat = new UnityEvent();

    [SerializeField] private float initialBeatPeriod;
    [SerializeField] private float offBeatOffset;
    
    [SerializeField] private float beatMultiplierPerBeat;

    private float currentBeatPeriod;
    private float currentTimer = 0f;
    private float currentOffBeatTimer = 0f;

    public void Start()
    {
        currentBeatPeriod = initialBeatPeriod;
        Beat.AddListener(UpdateBeat);
        OffBeat.AddListener(DisplayOffBeat);
        currentTimer = offBeatOffset;
    }
    

    public void UpdateBeat()
    {
        Debug.Log("Beat");
        Camera.main.transform.DOPunchPosition(new Vector3(0.25f,0.25f,0.25f),0.2f,5,1f);
        currentBeatPeriod *= beatMultiplierPerBeat;
    }

    public void DisplayOffBeat()
    {
        Debug.Log("OffBeat");
    }
    public void Update()
    {
        currentTimer += Time.deltaTime;
        if (currentTimer >= currentBeatPeriod)
        {
            currentTimer = 0f;
            Beat.Invoke();
        }

        currentOffBeatTimer += Time.deltaTime;
        if (currentOffBeatTimer >= currentBeatPeriod)
        {
            currentOffBeatTimer = 0f;
            OffBeat.Invoke();
        }
    }
}