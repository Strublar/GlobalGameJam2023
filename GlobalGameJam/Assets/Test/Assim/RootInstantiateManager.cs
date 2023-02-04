using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RootInstantiateManager : MonoBehaviour
{

    public int rootsAmount = 10;
    public Vector2 mapSize = new Vector2(20, 20);
    public Vector3 mapOrigin;
    public GameObject rootPrefab;
    private List<GameObject> livingRoots = new List<GameObject>();

    private void Start()
    {
        InstantiateRoots();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.I))
        {
            ClearRoots();
            InstantiateRoots();
        }
    }

    void InstantiateRoots() 
    {
        for (int i = 0; i < rootsAmount; i++)
        {
            GameObject newRoot = Instantiate(rootPrefab, mapOrigin + new Vector3(Random.Range(-mapSize.x, mapSize.x), 0, Random.Range(-mapSize.y, mapSize.y)),Quaternion.Euler(90,0,0));
            livingRoots.Add(newRoot);
        }
    }

    void ClearRoots()
    {
        for (int i = 0; i < livingRoots.Count; i++)
        {
            Destroy(livingRoots[i].gameObject);
        }
        livingRoots.Clear();
    }
}
