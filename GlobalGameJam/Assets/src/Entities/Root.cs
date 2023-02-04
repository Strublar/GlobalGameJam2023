using System;
using System.Collections;
using System.Collections.Generic;
using src;
using Unity.VisualScripting;
using UnityEngine;


public enum RootState
{
    Expanding,
    Expanded,
    Cut
}

public class Root : MonoBehaviour
{
    [SerializeField] private GameObject expandingRoot;

    private RootsManager manager;
    private SpawnPoint spawnPoint;
    private SpawnPoint target;
    private RootState state = RootState.Expanding;

    public void Init(SpawnPoint spawnPoint, SpawnPoint target, RootsManager manager)
    {
        this.spawnPoint = spawnPoint;
        this.target = target;
        this.manager = manager;

        transform.LookAt(target.transform);
        StartCoroutine(Expand());
    }

    IEnumerator Expand()
    {
        Vector3 startVector = new Vector3(1, 1, 0);
        var currentDuration = 0f;
        
        while (state == RootState.Expanding)
        {
            currentDuration += Time.deltaTime;
            expandingRoot.transform.localScale =
                Vector3.Lerp(startVector, 
                    startVector+Vector3.forward * Vector3.Distance(spawnPoint.transform.position, target.transform.position),
                    currentDuration / manager.expandDuration);
            if (currentDuration >= manager.expandDuration)
                state = RootState.Expanded;
            yield return null;
        }
        if(state == RootState.Expanded)
            manager.SpawnRootAtTarget(target);
    }
}