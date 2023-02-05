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
    [SerializeField] private float initialOffset;
    
    
    [SerializeField] private float beatMultiplierPerBeat;

    private float currentBeatPeriod;
    private float currentTimer = 0f;
    private float currentOffBeatTimer = 0f;
    private bool isOn = false;
    
    public void Init()
    {
        isOn = true;
        currentBeatPeriod = initialBeatPeriod;
        Beat.AddListener(UpdateBeat);
        OffBeat.AddListener(DisplayOffBeat);
        currentTimer = offBeatOffset+initialOffset;
        currentOffBeatTimer = initialOffset;
    }

    public void Stop()
    {
        isOn = false;
    }
    

    public void UpdateBeat()
    {
        Camera.main.transform.DOPunchPosition(new Vector3(0.25f,0.25f,0.25f),0.2f,5,1f);
        currentBeatPeriod *= beatMultiplierPerBeat;
        GameManager.instance.DoBeat();
    }

    public void DisplayOffBeat()
    {
    }
    public void Update()
    {
        if (!isOn)
            return;
        
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