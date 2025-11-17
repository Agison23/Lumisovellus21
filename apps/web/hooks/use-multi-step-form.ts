import { Obstacles } from '@/components/map-3d';
import { useState } from 'react';

export interface SnowConditionFormData {
  // Step 0 (Display): Area information - no inputs needed
  areaId: string | null;

  // Step 1 (Select): Snow type selection
  selectedSnowTypeId: string | null;
  obstacleIds: Obstacles | null; // Optional array of obstacle IDs
  description: string | null;
  timestamp: Date | null;
}

const initialFormData: SnowConditionFormData = {
  areaId: null,
  selectedSnowTypeId: null,
  obstacleIds: null,
  description: null,
  timestamp: null,
};

export function useMultiStepForm(
  initialData: Partial<SnowConditionFormData> = {},
  totalSteps: number = 3
) {
  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState<SnowConditionFormData>({
    ...initialFormData,
    ...initialData,
  });

  const goToStep = (step: number) => {
    if (step >= 0 && step < totalSteps) {
      setCurrentStep(step);
    }
  };

  const nextStep = () => {
    if (currentStep < totalSteps - 1) {
      setCurrentStep(currentStep + 1);
    }
  };

  const previousStep = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const updateFormData = (updates: Partial<SnowConditionFormData>) => {
    setFormData((prev) => ({ ...prev, ...updates }));
  };

  const reset = () => {
    setCurrentStep(0);
    setFormData({ ...initialFormData, ...initialData });
  };

  return {
    currentStep,
    formData,
    goToStep,
    nextStep,
    previousStep,
    updateFormData,
    reset,
    isFirstStep: currentStep === 0,
    isLastStep: currentStep === totalSteps - 1,
  };
}
