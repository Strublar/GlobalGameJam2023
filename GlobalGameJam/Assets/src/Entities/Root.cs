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
    }
    

    public void Cut()
    {
        state = RootState.Cut;
        Destroy(expandingRoot);
        if(isSeed)
            Destroy(gameObject);
        
    }
}