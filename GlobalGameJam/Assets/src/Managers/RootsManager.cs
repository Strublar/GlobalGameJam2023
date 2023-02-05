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

        [Header("Root generation management")] [SerializeField]
        private GameObject rootPrefab;

        [SerializeField] private float minRootRange;
        [SerializeField] private float maxRootRange;
        [SerializeField] private GameObject rootContainer;
        [SerializeField] private MeshRenderer ground;

        [Header("Spawn point management")] [SerializeField]
        private GameObject spawnPointContainer;


        [SerializeField] private float spawnRadiusMin;
        [SerializeField] private float spawnRadiusMax;



        public Vector3 rootsSpawnOffset;

        public Transform rootsTargetPoint;

        public float baseSpawnPerBeat = 0.3f;
        public float spawnAccelerationPerBeat = 0.03f;
        
        private float currentBeatProgression;
        private float currentSpawnPerBeat;

        private void Awake()
        {
            instance = this;
        }

        public void SpawnSeed(int amount)
        {
            Debug.Log("SPAWN");
            var minBound = ground.bounds.min;
            var maxBound = ground.bounds.max;
            Debug.Log((Random.Range(0, 2) * 2 - 1));
            //SpawnRootFromPosition(new Vector3(Random.Range(minBound.x, maxBound.x),0, Random.Range(minBound.z, maxBound.z)),3);
            for (int i = 0; i < amount; i++)
            {
                SpawnRootFromPosition(
                    new Vector3(Random.Range(spawnRadiusMin, spawnRadiusMax) * (Random.Range(0, 2) * 2 - 1), 0,
                        Random.Range(spawnRadiusMin, spawnRadiusMax) * (Random.Range(0, 2) * 2 - 1)), 3);
            }
        }

        public void SpawnRootFromPosition(Vector3 selectedSpawnPoint, int longevity, float parentRootAngle = 0)
        {
            float rootYRotation;

            if (longevity < 3)
            {
                rootYRotation = parentRootAngle + Random.Range(-60, 60);
            }
            else
            {
                rootYRotation = Quaternion
                    .LookRotation(rootsTargetPoint.position - selectedSpawnPoint, new Vector3(0, 1, 0)).eulerAngles.y;
            }

            var instantiatedRoot = Instantiate(rootPrefab,
                new Vector3(selectedSpawnPoint.x, rootsSpawnOffset.y, selectedSpawnPoint.z),
                Quaternion.Euler(90, rootYRotation, 0), rootContainer.transform);

            instantiatedRoot.GetComponent<RootVisual>().Longevity = longevity;
        }

        private void Start()
        {
            currentSpawnPerBeat = baseSpawnPerBeat;
            BeatManager.OffBeat.AddListener(SpawnOffBeat);
        }

        private void SpawnOffBeat()
        {
            currentBeatProgression += currentSpawnPerBeat;
            currentSpawnPerBeat += spawnAccelerationPerBeat;

            for (int i = 0; i < Mathf.FloorToInt(currentBeatProgression); i++)
            {
                SpawnSeed(1);
            }

            currentBeatProgression -= Mathf.FloorToInt(currentBeatProgression);
            /*
            if (currentBeatProgression >= currentSpawnPerBeat)
            {
                currentBeatProgression = 0;
                SpawnSeed(baseSpawnPerBeat);
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