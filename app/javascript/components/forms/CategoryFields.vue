<template>
  <div>
    <slot />

    <div v-for="{id, name, description, subcategories} in normalizedCategories" :key="id">
      <b-collapse
        :id="`collapse-${id}`"
        :aria-id="`collapse-content-${id}`"
        :open="isSelected(name)"
        class="card"
        animation="slide"
      >
        <div
          :aria-controls="`collapse-content-${id}`"
          slot="trigger"
          slot-scope="collapse"
          class="card-header"
          role="button"
        >
          <p class="card-header-title has-text-weight-normal is-size-4">
          {{ name | capitalize }}
          </p>
          <a class="card-header-icon">
            <b-icon :icon="collapse.open ? 'angle-up' : 'angle-down'" />
          </a>
        </div>

        <div class="card-content">
          <p v-if="description" class="mb-1"> {{ description }} </p>

          <!-- If any subcategories are selected, add parent category to list of tags submitted -->
          <input v-if="anySelected(subcategories)" :name="categoriesFieldName" :value="id" type="hidden" />

          <div v-for="{id: subId, name: subName, description: subDescription} in subcategories" :key="subId">
            <b-field grouped class="mb-1">
              <b-checkbox
                v-model="selectedTags"
                :name="categoriesFieldName"
                :native-value="subId"
                size="is-medium"
              >
                <span>{{ subName | capitalize }}</span>
                <span v-if="subDescription" class="is-size-6"> {{ "- " + subDescription }} </span>
              </b-checkbox>

              <b-select
                v-if="isSelected(subName)"
                :name="composeFieldName(detailsFieldNamePrefix, subId, 'urgency')"
                size="is-small"
                class="ml-1"
                placeholder="Urgency …"
              >
                <option
                  v-for="{id: urgencyId, name: urgencyName} in urgency_levels"
                  :key="urgencyId"
                  :value="urgencyId"
                >
                  {{ urgencyName }}
                </option>
              </b-select>
            </b-field>
          </div>
        </div>
      </b-collapse>
    </div>
  </div>
</template>

<script>
import {capitalize} from 'utils/string'
import {composeFieldName} from 'utils/form'

export default {
  name: 'CategoryFields',
  props: {
    categoriesFieldName:    String,
    categories:             Array,
    detailsFieldNamePrefix: String,
    tags:                   Array,
    urgency_levels:         Array,
  },
  data() {
    return {
      selectedTags: this.tags || [],
    }
  },
  computed: {
    normalizedCategories() {
      this.categories.forEach(({id, name, subcategories}) => {
        if (!subcategories.length) {
          subcategories.push({id, name})
        }
      })
      return this.categories
    },
  },
  methods: {
    isSelected(tagName) {
      return this.selectedTags.indexOf(tagName) >= 0
    },
    anySelected(subcategories) {
      return subcategories.find(({name}) => this.isSelected(name))
    },
    composeFieldName,
  },
  filters: { capitalize },
}
</script>
