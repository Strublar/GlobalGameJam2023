using System.Collections.Generic;
using UnityEngine;

namespace src
{
    public class RootsManager : MonoBehaviour
    {
        [SerializeField] private GameObject rootPrefab;
        [SerializeField] private float spawnPeriod;
        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;
        [SerializeField] private GameObject spawnPointContainer;
        private float currentTimer = 0f;

        // Start is called before the first frame update
        void Start()
        {
        
        }

        // Update is called once per frame

        public void SpawnRoot()
        {
            var availableSpawnPoints = spawnPointContainer.GetComponentsInChildren<Transform>();
            var selectedSpawnPoint = availableSpawnPoints[Random.Range(0, availableSpawnPoints.Length)];
            Instantiate(rootPrefab, selectedSpawnPoint.position, selectedSpawnPoint.rotation);
        }
        void Update()
        {
            currentTimer += Time.deltaTime;
            if (currentTimer >= spawnPeriod)
            {
                currentTimer = 0f;
                SpawnRoot();
            }
        }
    }
}