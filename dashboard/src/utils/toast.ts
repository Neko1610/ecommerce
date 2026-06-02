import { toast as hotToast } from 'react-hot-toast';

const options = { duration: 2000 };

const show = (callback: () => string) => {
  hotToast.dismiss();
  return callback();
};

const toast = {
  success(message: string) {
    return show(() => hotToast.success(message, options));
  },
  error(message: string) {
    return show(() => hotToast.error(message, options));
  },
};

export default toast;
