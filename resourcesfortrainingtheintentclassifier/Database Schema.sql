# Database Schema

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
JOIN RULES (ABSOLUTE)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All fact tables use (location_type, location_id) for location resolution.

**When location_type = 'DISTRICT':**
```sql
JOIN DISTRICT d 
  ON fact.location_type = 'DISTRICT' 
  AND fact.location_id = d.district_id
JOIN STATE s 
  ON d.state_id = s.state_id
```

**When location_type = 'STATE':**
```sql
JOIN STATE s 
  ON fact.location_type = 'STATE' 
  AND fact.location_id = s.state_id
```

**NEVER:**
- Join fact tables directly to STATE without checking location_type
- Join fact tables to DISTRICT when location_type = 'STATE'
- Use ILIKE on location_type or location_id columns

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Table: CROP
- crop_id (PRIMARY KEY)
- crop_name

## Table: SEASON
- season_id (PRIMARY KEY)
- season_name
- season_start
- season_end

## Table: STATE
- state_id (PRIMARY KEY)
- state_name
- state_latitude
- state_longitude
- state_area

## Table: DISTRICT
- district_id (PRIMARY KEY)
- district_name
- state_id (FOREIGN KEY → STATE.state_id)
- district_latitude
- district_longitude
- district_area

## Table: LOCATION_RAINFALL
- location_rainfall_id (PRIMARY KEY)
- location_type (VALUE: 'STATE' or 'DISTRICT') **MUST BE USED IN JOIN**
- location_id (CONDITIONAL FOREIGN KEY)
- rainfall_value
- rainfall_recorded_date
- rainfall_recorded_year
- rainfall_data_collection_id (FOREIGN KEY → RAINFALL_DATA_COLLECTION.rainfall_data_collection_id)

**JOIN PATTERN FOR DISTRICT:**
```sql
FROM LOCATION_RAINFALL lr
JOIN DISTRICT d ON lr.location_type = 'DISTRICT' AND lr.location_id = d.district_id
JOIN STATE s ON d.state_id = s.state_id
```

**JOIN PATTERN FOR STATE:**
```sql
FROM LOCATION_RAINFALL lr
JOIN STATE s ON lr.location_type = 'STATE' AND lr.location_id = s.state_id
```

## Table: LOCATION_TEMPERATURE
- location_temperature_id (PRIMARY KEY)
- location_type (VALUE: 'STATE' or 'DISTRICT') **MUST BE USED IN JOIN**
- location_id (CONDITIONAL FOREIGN KEY)
- temperature_value
- temperature_recorded_date
- temperature_recorded_year
- temperature_data_collection_id (FOREIGN KEY → TEMPERATURE_DATA_COLLECTION.temperature_data_collection_id)

**JOIN PATTERN FOR DISTRICT:**
```sql
FROM LOCATION_TEMPERATURE lt
JOIN DISTRICT d ON lt.location_type = 'DISTRICT' AND lt.location_id = d.district_id
JOIN STATE s ON d.state_id = s.state_id
```

**JOIN PATTERN FOR STATE:**
```sql
FROM LOCATION_TEMPERATURE lt
JOIN STATE s ON lt.location_type = 'STATE' AND lt.location_id = s.state_id
```

## Table: LOCATION_RESERVOIR_LEVEL
- location_reservoir_level_id (PRIMARY KEY)
- location_type (VALUE: 'STATE' or 'DISTRICT') **MUST BE USED IN JOIN**
- location_id (CONDITIONAL FOREIGN KEY)
- frl
- level
- current_live_storage
- reservoir_level_recorded_date
- reservoir_level_recorded_year
- reservoir_level_data_collection_id (FOREIGN KEY → RESERVOIR_LEVEL_DATA_COLLECTION.reservoir_level_data_collection_id)

**JOIN PATTERN FOR DISTRICT:**
```sql
FROM LOCATION_RESERVOIR_LEVEL lrl
JOIN DISTRICT d ON lrl.location_type = 'DISTRICT' AND lrl.location_id = d.district_id
JOIN STATE s ON d.state_id = s.state_id
```

**JOIN PATTERN FOR STATE:**
```sql
FROM LOCATION_RESERVOIR_LEVEL lrl
JOIN STATE s ON lrl.location_type = 'STATE' AND lrl.location_id = s.state_id
```

## Table: RAINFALL_DATA_COLLECTION
- rainfall_data_collection_id (PRIMARY KEY)
- rainfall_data_collection_rainfall_unit
- rainfall_data_collection_rainfall_recorded_interval_unit

## Table: TEMPERATURE_DATA_COLLECTION
- temperature_data_collection_id (PRIMARY KEY)
- temperature_data_collection_temperature_type
- temperature_data_collection_temperature_unit
- temperature_data_collection_temperature_recorded_interval_unit

## Table: RESERVOIR_LEVEL_DATA_COLLECTION
- reservoir_level_data_collection_id (PRIMARY KEY)

## Table: FEATURE_MASTER
- feature_id (PRIMARY KEY)
- feature_title
- feature_description
- feature_data_category
- feature_temporal_interval
- feature_location_level
- feature_is_active

## Table: TRAINING_FEATURE_SET
- training_feature_set_id (PRIMARY KEY)
- training_feature_set_title
- training_feature_set_description
- no_of_features
- training_feature_set_is_active

## Table: TRAINING_FEATURE_SET_FEATURE
- training_feature_set_feature_id (PRIMARY KEY)
- training_feature_set_id (FOREIGN KEY → TRAINING_FEATURE_SET.training_feature_set_id)
- feature_id (FOREIGN KEY → FEATURE_MASTER.feature_id)
- is_feature_target

## Table: TRAINING_FEATURE_SET_DATA
- training_feature_set_data_id (PRIMARY KEY)
- training_feature_set_id (FOREIGN KEY → TRAINING_FEATURE_SET.training_feature_set_id)
- training_feature_set_data_title
- training_feature_set_data_crops (JSON ARRAY)
- training_feature_set_data_seasons (JSON ARRAY)
- training_feature_set_data_location_level
- training_feature_set_data_locations (JSON ARRAY)
- training_feature_set_data_start_year
- training_feature_set_data_end_year

## Table: TRAINING_FEATURE_SET_DATA_INDIVIDUAL_FEATURE
- training_feature_set_data_individual_feature_id (PRIMARY KEY)
- training_feature_set_data_id (FOREIGN KEY → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id)
- training_feature_set_data_individual_feature_title
- training_feature_set_data_individual_feature_description

## Table: TRAINING_FEATURE_SET_DATA_SOURCE_COLLECTION
- training_feature_set_data_source_collection_id (PRIMARY KEY)
- training_feature_set_data_id (FOREIGN KEY → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id)
- data_source_collection_data_category
- data_source_collection_id

## Table: TRAINING_FEATURE_SET_FEATURE_TEMPORAL_INTERVAL_ITEM
- training_feature_set_feature_temporal_interval_item_id (PRIMARY KEY)
- training_feature_set_feature_id (FOREIGN KEY → TRAINING_FEATURE_SET_FEATURE.training_feature_set_feature_id)
- temporal_interval_item_start
- temporal_interval_item_end
- temporal_interval_item_base_year

## Table: TRAINING_DATASET_COLLECTION
- training_dataset_collection_id (PRIMARY KEY)
- training_dataset_collection_title
- training_dataset_collection_description

## Table: TRAINING_DATASET_COLLECTION_ITEM
- training_dataset_collection_item_id (PRIMARY KEY)
- training_dataset_collection_id (FOREIGN KEY → TRAINING_DATASET_COLLECTION.training_dataset_collection_id)
- training_feature_set_data_id (FOREIGN KEY → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id)

## Table: MODEL_BUILD_ALGORITHM
- model_build_algorithm_id (PRIMARY KEY)
- model_build_algorithm_name
- model_build_algorithm_description

## Table: MODEL_BUILD_ALGORITHM_HYPERPARAMETER
- model_build_algorithm_hyperparameter_id (PRIMARY KEY)
- model_build_algorithm_id (FOREIGN KEY → MODEL_BUILD_ALGORITHM.model_build_algorithm_id)
- model_build_algorithm_hyperparameter_name
- model_build_algorithm_hyperparameter_data_type
- model_build_algorithm_hyperparameter_mandatory
- model_build_algorithm_hyperparameter_default_value

## Table: MODEL_BUILD_CONFIG_COLLECTION
- model_build_config_collection_id (PRIMARY KEY)
- model_build_config_collection_title
- model_build_config_collection_description

## Table: MODEL_BUILD_CONFIG
- model_build_config_id (PRIMARY KEY)
- model_build_config_title
- model_build_config_description

## Table: MODEL_BUILD_CONFIG_COLLECTION_ITEM
- model_build_config_collection_item_id (PRIMARY KEY)
- model_build_config_collection_id (FOREIGN KEY → MODEL_BUILD_CONFIG_COLLECTION.model_build_config_collection_id)
- model_build_config_id (FOREIGN KEY → MODEL_BUILD_CONFIG.model_build_config_id)

## Table: MODEL_BUILD_CONFIG_ITEM
- model_build_config_item_id (PRIMARY KEY)
- model_build_config_id (FOREIGN KEY → MODEL_BUILD_CONFIG.model_build_config_id)
- model_build_config_item_type
- model_build_config_item_key
- model_build_config_item_value

## Table: MODEL_BUILD_BATCH_RUN
- model_build_batch_run_id (PRIMARY KEY)
- model_build_batch_run_title
- model_build_batch_run_description
- training_dataset_collection_id (FOREIGN KEY → TRAINING_DATASET_COLLECTION.training_dataset_collection_id)
- model_build_config_collection_id (FOREIGN KEY → MODEL_BUILD_CONFIG_COLLECTION.model_build_config_collection_id)
- model_build_batch_run_start_time
- model_build_batch_run_end_time
- model_build_batch_run_status

## Table: MODEL_BUILD_RUN
- model_build_run_id (PRIMARY KEY)
- model_build_run_title
- model_build_run_description
- model_build_batch_run_id (FOREIGN KEY → MODEL_BUILD_BATCH_RUN.model_build_batch_run_id)
- training_dataset_collection_item_id (FOREIGN KEY → TRAINING_DATASET_COLLECTION_ITEM.training_dataset_collection_item_id)
- model_build_config_collection_item_id (FOREIGN KEY → MODEL_BUILD_CONFIG_COLLECTION_ITEM.model_build_config_collection_item_id)
- model_build_run_start_time
- model_build_run_end_time

## Table: MODEL_BUILD_RUN_ARTIFACT
- model_build_run_artifact_id (PRIMARY KEY)
- model_build_run_id (FOREIGN KEY → MODEL_BUILD_RUN.model_build_run_id)
- model_build_run_artifact_title
- model_build_run_artifact_description
- model_build_run_artifact_type
- modelbuild_run_artifact_iceberg_minio_bucket
- modelbuild_run_artifact_iceberg_minio_filename

## Table: MODEL_BUILD_RUN_METRIC
- model_build_run_metric_id (PRIMARY KEY)
- model_build_run_id (FOREIGN KEY → MODEL_BUILD_RUN.model_build_run_id)
- model_build_run_metric_source
- model_build_run_metric_key
- model_build_run_metric_value

## Table: FORECAST_CONFIG_COLLECTION
- forecast_config_collection_id (PRIMARY KEY)
- forecast_config_collection_title
- forecast_config_collection_description

## Table: FORECAST_EXOGENEOUS_DATA_ESTIMATION_CONFIG_COLLECTION
- forecast_exogeneous_data_estimation_config_collection_id (PRIMARY KEY)
- forecast_exogeneous_data_estimation_config_collection_title

## Table: FORECAST_BATCH
- forecast_batch_id (PRIMARY KEY)
- forecast_batch_title
- forecast_build_batch_description
- forecast_config_collection_id (FOREIGN KEY → FORECAST_CONFIG_COLLECTION.forecast_config_collection_id)
- forecast_exogeneous_data_estimation_config_collection_id (FOREIGN KEY → FORECAST_EXOGENEOUS_DATA_ESTIMATION_CONFIG_COLLECTION.forecast_exogeneous_data_estimation_config_collection_id)

## Table: FORECAST_BATCH_RUN
- forecast_batch_run_id (PRIMARY KEY)
- forecast_batch_run_title
- forecast_batch_run_description
- forecast_batch_id (FOREIGN KEY → FORECAST_BATCH.forecast_batch_id)
- forecast_batch_run_start_time
- forecast_batch_run_end_time
- forecast_batch_run_status

## Table: FORECAST_CONFIG
- forecast_config_id (PRIMARY KEY)
- forecast_config_title
- forecast_config_description
- model_build_run_artifact_id (FOREIGN KEY → MODEL_BUILD_RUN_ARTIFACT.model_build_run_artifact_id)
- forecast_config_collection_id (FOREIGN KEY → FORECAST_CONFIG_COLLECTION.forecast_config_collection_id)

## Table: FORECAST_RUN
- forecast_run_id (PRIMARY KEY)
- forecast_run_title
- forecast_run_description
- forecast_batch_run_id (FOREIGN KEY → FORECAST_BATCH_RUN.forecast_batch_run_id)
- forecast_config_id (FOREIGN KEY → FORECAST_CONFIG.forecast_config_id)
- forecast_run_start_time
- forecast_run_end_time
- forecast_run_status

## Table: FORECAST_RUN_RESULT
- forecast_run_result_id (PRIMARY KEY)
- forecast_run_id (FOREIGN KEY → FORECAST_RUN.forecast_run_id)
- forecast_run_result
- forecast_run_value_of_exogenous_features

---

## Relationship Summary

### Location Hierarchy
DISTRICT.state_id → STATE.state_id

### Weather Data (Polymorphic - CRITICAL JOIN RULES)

**LOCATION_RAINFALL joins:**
- When location_type='DISTRICT': 
  LOCATION_RAINFALL → DISTRICT (ON location_type='DISTRICT' AND location_id=district_id) → STATE
- When location_type='STATE':
  LOCATION_RAINFALL → STATE (ON location_type='STATE' AND location_id=state_id)

**LOCATION_TEMPERATURE joins:**
- When location_type='DISTRICT':
  LOCATION_TEMPERATURE → DISTRICT (ON location_type='DISTRICT' AND location_id=district_id) → STATE
- When location_type='STATE':
  LOCATION_TEMPERATURE → STATE (ON location_type='STATE' AND location_id=state_id)

**LOCATION_RESERVOIR_LEVEL joins:**
- When location_type='DISTRICT':
  LOCATION_RESERVOIR_LEVEL → DISTRICT (ON location_type='DISTRICT' AND location_id=district_id) → STATE
- When location_type='STATE':
  LOCATION_RESERVOIR_LEVEL → STATE (ON location_type='STATE' AND location_id=state_id)

**NEVER directly join LOCATION_* tables to STATE without checking location_type**

### Weather Data Collections
LOCATION_RAINFALL.rainfall_data_collection_id → RAINFALL_DATA_COLLECTION.rainfall_data_collection_id
LOCATION_TEMPERATURE.temperature_data_collection_id → TEMPERATURE_DATA_COLLECTION.temperature_data_collection_id
LOCATION_RESERVOIR_LEVEL.reservoir_level_data_collection_id → RESERVOIR_LEVEL_DATA_COLLECTION.reservoir_level_data_collection_id

### Feature Engineering
TRAINING_FEATURE_SET_FEATURE.training_feature_set_id → TRAINING_FEATURE_SET.training_feature_set_id
TRAINING_FEATURE_SET_FEATURE.feature_id → FEATURE_MASTER.feature_id
TRAINING_FEATURE_SET_DATA.training_feature_set_id → TRAINING_FEATURE_SET.training_feature_set_id
TRAINING_FEATURE_SET_DATA_INDIVIDUAL_FEATURE.training_feature_set_data_id → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id
TRAINING_FEATURE_SET_DATA_SOURCE_COLLECTION.training_feature_set_data_id → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id
TRAINING_FEATURE_SET_FEATURE_TEMPORAL_INTERVAL_ITEM.training_feature_set_feature_id → TRAINING_FEATURE_SET_FEATURE.training_feature_set_feature_id

### Training Dataset
TRAINING_DATASET_COLLECTION_ITEM.training_dataset_collection_id → TRAINING_DATASET_COLLECTION.training_dataset_collection_id
TRAINING_DATASET_COLLECTION_ITEM.training_feature_set_data_id → TRAINING_FEATURE_SET_DATA.training_feature_set_data_id

### Model Algorithm
MODEL_BUILD_ALGORITHM_HYPERPARAMETER.model_build_algorithm_id → MODEL_BUILD_ALGORITHM.model_build_algorithm_id

### Model Configuration
MODEL_BUILD_CONFIG_COLLECTION_ITEM.model_build_config_collection_id → MODEL_BUILD_CONFIG_COLLECTION.model_build_config_collection_id
MODEL_BUILD_CONFIG_COLLECTION_ITEM.model_build_config_id → MODEL_BUILD_CONFIG.model_build_config_id
MODEL_BUILD_CONFIG_ITEM.model_build_config_id → MODEL_BUILD_CONFIG.model_build_config_id

### Model Training
MODEL_BUILD_BATCH_RUN.training_dataset_collection_id → TRAINING_DATASET_COLLECTION.training_dataset_collection_id
MODEL_BUILD_BATCH_RUN.model_build_config_collection_id → MODEL_BUILD_CONFIG_COLLECTION.model_build_config_collection_id
MODEL_BUILD_RUN.model_build_batch_run_id → MODEL_BUILD_BATCH_RUN.model_build_batch_run_id
MODEL_BUILD_RUN.training_dataset_collection_item_id → TRAINING_DATASET_COLLECTION_ITEM.training_dataset_collection_item_id
MODEL_BUILD_RUN.model_build_config_collection_item_id → MODEL_BUILD_CONFIG_COLLECTION_ITEM.model_build_config_collection_item_id
MODEL_BUILD_RUN_ARTIFACT.model_build_run_id → MODEL_BUILD_RUN.model_build_run_id
MODEL_BUILD_RUN_METRIC.model_build_run_id → MODEL_BUILD_RUN.model_build_run_id

### Forecasting
FORECAST_BATCH.forecast_config_collection_id → FORECAST_CONFIG_COLLECTION.forecast_config_collection_id
FORECAST_BATCH.forecast_exogeneous_data_estimation_config_collection_id → FORECAST_EXOGENEOUS_DATA_ESTIMATION_CONFIG_COLLECTION.forecast_exogeneous_data_estimation_config_collection_id
FORECAST_BATCH_RUN.forecast_batch_id → FORECAST_BATCH.forecast_batch_id
FORECAST_CONFIG.model_build_run_artifact_id → MODEL_BUILD_RUN_ARTIFACT.model_build_run_artifact_id
FORECAST_CONFIG.forecast_config_collection_id → FORECAST_CONFIG_COLLECTION.forecast_config_collection_id
FORECAST_RUN.forecast_batch_run_id → FORECAST_BATCH_RUN.forecast_batch_run_id
FORECAST_RUN.forecast_config_id → FORECAST_CONFIG.forecast_config_id
FORECAST_RUN_RESULT.forecast_run_id → FORECAST_RUN.forecast_run_id