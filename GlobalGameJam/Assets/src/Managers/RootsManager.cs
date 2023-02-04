using System;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

namespace src
{
    public class RootsManager : MonoBehaviour
    {
        public static RootsManager instance;
        
        [Header("Root behaviour")] 
        public float expandDuration;

        [Header("Root generation management")]
        [SerializeField] private GameObject rootPrefab;
        [SerializeField] private float baseSpawnPeriod;
        [SerializeField] private float spawnPeriodMultiplierPerSpawn;
        
        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;
        
        [Header("Spawn point management")]
        [SerializeField] private GameObject spawnPointContainer;
        [SerializeField] private GameObject rootContainer;

        /*private float currentSpawnPeriod;
        private float currentTimer = 0f;*/

        private void Awake()
        {
            instance = this;
        }
        
        public void SpawnSeed()
        {
            SpawnPoint[] availableSpawnPoints = spawnPointContainer.GetComponentsInChildren<SpawnPoint>();
            SpawnPoint selectedSpawnPoint = availableSpawnPoints[Random.Range(0, availableSpawnPoints.Length)];
            SpawnRootAtTarget(selectedSpawnPoint,true);

        }

        public void SpawnRootAtTarget(SpawnPoint selectedSpawnPoint,bool isSeed)
        {
            Transform selectedTransform = selectedSpawnPoint.transform;
            var instantiatedRoot = Instantiate(rootPrefab, selectedTransform.position,
                selectedTransform.rotation, rootContainer.transform);
            instantiatedRoot.GetComponent<Root>().Init(selectedSpawnPoint,selectedSpawnPoint.getRandomNeighbour(),this, isSeed);
        }

        private void Start()
        {
            BeatManager.OffBeat.AddListener(SpawnSeed);
        }

        void Update()
        {
            /*currentTimer += Time.deltaTime;
            if (currentTimer >= currentSpawnPeriod)
            {
                currentTimer = 0f;
                currentSpawnPeriod *= spawnPeriodMultiplierPerSpawn;
                SpawnSeed();
            }*/
            
        }

        public float GetMinRootRange()
        {
            return minRootRange;
        }
        public float GetMaxRootRange()
        {
            return maxRootRange;
        }
    }
}