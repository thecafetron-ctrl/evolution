import { InstanceDto } from '@api/dto/instance.dto';
import {
  SendAudioDto,
  SendButtonsDto,
  SendContactDto,
  SendListDto,
  SendLocationDto,
  SendMediaDto,
  SendPollDto,
  SendPtvDto,
  SendReactionDto,
  SendStatusDto,
  SendStickerDto,
  SendTemplateDto,
  SendTextDto,
} from '@api/dto/sendMessage.dto';
import { WAMonitoringService } from '@api/services/monitor.service';
import { BadRequestException, NotFoundException } from '@exceptions';
import { isBase64, isURL } from 'class-validator';
import emojiRegex from 'emoji-regex';

const regex = emojiRegex();

function isEmoji(str: string) {
  if (str === '') return true;

  const match = str.match(regex);
  return match?.length === 1 && match[0] === str;
}

export class SendMessageController {
  constructor(private readonly waMonitor: WAMonitoringService) {}

  private async getInstance(instanceName: string) {
    // Try to get from memory or load from database
    const instance = await this.waMonitor.getOrLoadInstance(instanceName);
    if (!instance) {
      throw new NotFoundException(`Instance "${instanceName}" not found. Please create the instance first.`);
    }
    return instance;
  }

  public async sendTemplate({ instanceName }: InstanceDto, data: SendTemplateDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.templateMessage(data);
  }

  public async sendText({ instanceName }: InstanceDto, data: SendTextDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.textMessage(data);
  }

  public async sendMedia({ instanceName }: InstanceDto, data: SendMediaDto, file?: any) {
    if (isBase64(data?.media) && !data?.fileName && data?.mediatype === 'document') {
      throw new BadRequestException('For base64 the file name must be informed.');
    }

    if (file || isURL(data?.media) || isBase64(data?.media)) {
      const instance = await this.getInstance(instanceName);
      return await instance.mediaMessage(data, file);
    }
    throw new BadRequestException('Owned media must be a url or base64');
  }

  public async sendPtv({ instanceName }: InstanceDto, data: SendPtvDto, file?: any) {
    if (file || isURL(data?.video) || isBase64(data?.video)) {
      const instance = await this.getInstance(instanceName);
      return await instance.ptvMessage(data, file);
    }
    throw new BadRequestException('Owned media must be a url or base64');
  }

  public async sendSticker({ instanceName }: InstanceDto, data: SendStickerDto, file?: any) {
    if (file || isURL(data.sticker) || isBase64(data.sticker)) {
      const instance = await this.getInstance(instanceName);
      return await instance.mediaSticker(data, file);
    }
    throw new BadRequestException('Owned media must be a url or base64');
  }

  public async sendWhatsAppAudio({ instanceName }: InstanceDto, data: SendAudioDto, file?: any) {
    if (file?.buffer || isURL(data.audio) || isBase64(data.audio)) {
      const instance = await this.getInstance(instanceName);
      return await instance.audioWhatsapp(data, file);
    } else {
      console.error('El archivo no tiene buffer o el audio no es una URL o Base64 válida');
      throw new BadRequestException('Owned media must be a url, base64, or valid file with buffer');
    }
  }

  public async sendButtons({ instanceName }: InstanceDto, data: SendButtonsDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.buttonMessage(data);
  }

  public async sendLocation({ instanceName }: InstanceDto, data: SendLocationDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.locationMessage(data);
  }

  public async sendList({ instanceName }: InstanceDto, data: SendListDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.listMessage(data);
  }

  public async sendContact({ instanceName }: InstanceDto, data: SendContactDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.contactMessage(data);
  }

  public async sendReaction({ instanceName }: InstanceDto, data: SendReactionDto) {
    if (!isEmoji(data.reaction)) {
      throw new BadRequestException('Reaction must be a single emoji or empty string');
    }
    const instance = await this.getInstance(instanceName);
    return await instance.reactionMessage(data);
  }

  public async sendPoll({ instanceName }: InstanceDto, data: SendPollDto) {
    const instance = await this.getInstance(instanceName);
    return await instance.pollMessage(data);
  }

  public async sendStatus({ instanceName }: InstanceDto, data: SendStatusDto, file?: any) {
    const instance = await this.getInstance(instanceName);
    return await instance.statusMessage(data, file);
  }
}
