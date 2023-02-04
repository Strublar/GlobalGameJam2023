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
        [SerializeField] private GameObject rootContainer;
        [SerializeField] private MeshRenderer ground;

        [Header("Spawn point management")] [SerializeField]
        private GameObject spawnPointContainer;

        

        private int currentBeatCount;
        private int currentSpawnPeriod;

        private void Awake()
        {
            instance = this;
        }

        public void SpawnSeed()
        {
            var minBound = ground.bounds.min;
            var maxBound = ground.bounds.max;
            SpawnRootFromPosition(new Vector3(Random.Range(minBound.x, maxBound.x),0, Random.Range(minBound.z, maxBound.z)), true);
        }

        public void SpawnRootFromPosition(Vector3 selectedSpawnPoint, bool isSeed)
        {
            
            var instantiatedRoot = Instantiate(rootPrefab, selectedSpawnPoint,
                Quaternion.identity, rootContainer.transform);
            instantiatedRoot.GetComponent<Root>()
                .Init(selectedSpawnPoint, this, isSeed);
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