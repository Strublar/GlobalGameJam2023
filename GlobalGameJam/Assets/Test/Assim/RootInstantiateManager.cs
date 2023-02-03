using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RootInstantiateManager : MonoBehaviour
{

    public int rootsAmount = 10;
    public Vector2 mapSize = new Vector2(20, 20);
    public Vector3 mapOrigin;
    public GameObject rootPrefab;

    private void Start()
    {
        InstantiateRoots();
    }

    void InstantiateRoots() 
    {
        for (int i = 0; i < rootsAmount; i++)
        {
            
        }
    }
}
