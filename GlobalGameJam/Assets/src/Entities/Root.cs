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
    [SerializeField] private GameObject rootModel;
    [SerializeField] private GameObject gameManager;
    
    

    private RootsManager manager;
    private Vector3 spawnPoint;
    private RootState state = RootState.Expanding;

    private bool isSeed;
    public void Init(Vector3 spawnPoint, RootsManager manager, bool isSeed)
    {
        this.spawnPoint = spawnPoint;
        this.manager = manager;
        this.isSeed = isSeed;
        
        // transform.LookAt(target.transform);
        StartCoroutine(Expand());
    }

    IEnumerator Expand()
    {
        yield return null;
        // Vector3 startVector = new Vector3(1, 1, 0);
        // var currentDuration = 0f;
        //
        // while (state == RootState.Expanding)
        // {
        //     currentDuration += Time.deltaTime;
        //     expandingRoot.transform.localScale =
        //         Vector3.Lerp(startVector, 
        //             startVector+Vector3.forward * Vector3.Distance(spawnPoint, target.transform.position),
        //             currentDuration / manager.expandDuration);
        //     if (currentDuration >= manager.expandDuration)
        //         state = RootState.Expanded;
        //     yield return null;
        // }
        // if (state == RootState.Expanded)
        // {
        //     manager.SpawnRootFromPosition(target,false);
        //     foreach (Transform current in expandingRoot.transform)
        //     {
        //         current.gameObject.tag = "Wall";
        //         rootModel.GetComponent<MeshRenderer>().material.color = Color.magenta;
        //     }
        // }
    }

    public void Cut()
    {
        state = RootState.Cut;
        Destroy(expandingRoot);
        if(isSeed)
            Destroy(gameObject);
        
    }
}