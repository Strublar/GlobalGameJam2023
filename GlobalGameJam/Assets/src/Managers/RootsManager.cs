using System;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

namespace src
{
    public class RootsManager : MonoBehaviour
    {
        public static RootsManager instance;

        [Header("Root behaviour")] public float expandDuration;

        [Header("Root generation management")] 
        [SerializeField] private GameObject rootPrefab;

        [SerializeField] private int baseSpawnPeriod;
        //[SerializeField] private  spawnPeriodMultiplierPerSpawn;

        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;

        [Header("Spawn point management")] [SerializeField]
        private GameObject spawnPointContainer;

        [SerializeField] private GameObject rootContainer;

        private int currentBeatCount;
        private int currentSpawnPeriod;

        private void Awake()
        {
            instance = this;
        }

        public void SpawnSeed()
        {
            SpawnPoint[] availableSpawnPoints = spawnPointContainer.GetComponentsInChildren<SpawnPoint>();
            SpawnPoint selectedSpawnPoint = availableSpawnPoints[Random.Range(0, availableSpawnPoints.Length)];
            SpawnRootAtTarget(selectedSpawnPoint, true);
        }

        public void SpawnRootAtTarget(SpawnPoint selectedSpawnPoint, bool isSeed)
        {
            var selectedTransform = selectedSpawnPoint.transform;
            var instantiatedRoot = Instantiate(rootPrefab, selectedTransform.position,
                selectedTransform.rotation, rootContainer.transform);
            instantiatedRoot.GetComponent<Root>()
                .Init(selectedSpawnPoint, selectedSpawnPoint.getRandomNeighbour(), this, isSeed);
        }

        private void Start()
        {
            currentSpawnPeriod = baseSpawnPeriod;
            BeatManager.OffBeat.AddListener(SpawnOffBeat);
        }

        private void SpawnOffBeat()
        {
            currentBeatCount++;
            if (currentBeatCount >= currentSpawnPeriod)
            {
                currentBeatCount = 0;
                SpawnSeed();
            }
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